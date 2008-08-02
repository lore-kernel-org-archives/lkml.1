Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbYHBQHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbYHBQHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 12:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYHBQHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 12:07:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:46760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYHBQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=H/4bHTiWocuoumJju5QeYpbiOOuanGwJMaeVrYOnNi4bXZ4RbhaKG0ooiqastuKeFt
         /Df4IbnuDhETUZNhQbUREdxP+pikWOu6TMpaKKSCx7JB6xTyBx9vncVom48vyXbks1Bs
         XyzpIwSuT7UaQhOCYWTuTDLC6D5Mx3cP5xD3U=
Message-ID: <b9df5fa10808020907g774a88ddj8111a5ffcbe62eb5@mail.gmail.com>
Date: Sat, 2 Aug 2008 22:07:32 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: pj@sgi.com, menage@google.com
Subject: [PATCH] Removes extra checking kernel/cpuset.c
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,  in 'update_domain_attr' function we can just return if
couldn't update domain attribute , rather then checking dattr and
again checking relax_domain_level of dattr , if not then return.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.26-rc9.orig/kernel/cpuset.c	2008-08-01 08:38:41.000000000 +0600
+++ linux-2.6.26-rc9/kernel/cpuset.c	2008-08-02 20:37:06.000000000 +0600
@@ -490,8 +490,6 @@ static int cpusets_overlap(struct cpuset
 static void
 update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 {
-	if (!dattr)
-		return;
 	if (dattr->relax_domain_level < c->relax_domain_level)
 		dattr->relax_domain_level = c->relax_domain_level;
 	return;

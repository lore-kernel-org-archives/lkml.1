Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYGRHk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYGRHk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYGRHj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:39:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYGRHj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z+zMogMxAZJQ+N275aBfzGRQV6Z9dMOe/fgDLySnPMb93ITMtuRuXahV5Q1zgDrYdl
         rgNdPeysk6xEaFfc36yVyfdSz/7x9gK9aQFVNiJognaGBJH9NxH3tmzD0cfcS6L30U8j
         ezjFDSqwZuUje3iCqCpjmcSwGtTKjQ244JiZM=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 16:40:10 +0900
Message-Id: <20080718074010.32713.22016.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
Subject: [PATCH 01/05] resource: add resource_size()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Avoid one-off errors by introducing a resource_size() function.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/ioport.h |    4 ++++
 kernel/resource.c      |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- 0001/include/linux/ioport.h
+++ work/include/linux/ioport.h	2008-07-09 12:59:04.000000000 +0900
@@ -113,6 +113,10 @@ extern int allocate_resource(struct reso
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 resource_size_t resource_alignment(struct resource *res);
+static inline resource_size_t resource_size(struct resource *res)
+{
+	return res->end - res->start + 1;
+}
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
--- 0001/kernel/resource.c
+++ work/kernel/resource.c	2008-07-09 12:59:41.000000000 +0900
@@ -490,7 +490,7 @@ resource_size_t resource_alignment(struc
 {
 	switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
 	case IORESOURCE_SIZEALIGN:
-		return res->end - res->start + 1;
+		return resource_size(res);
 	case IORESOURCE_STARTALIGN:
 		return res->start;
 	default:

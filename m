Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbZDFWR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbZDFWR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbZDFWRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:17:04 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:58103 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbZDFWRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=lw9N60bOdKUN/L0RsBz+RJ1EkYfVhO7l3a27/kOmxrkNlQaJyvsXE6EwOk9feP5fVH
         O18fOYEJWNMj+Gi0jy3OLTXeeIk9toFeU600volY+jJKMfBVCpyTVIeqO1tidMBSSdos
         BlwurNJgk8q5WRt04hEQfpNrTogPXsVG03VsU=
Date: Mon, 6 Apr 2009 18:16:49 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: jens.axboe@oracle.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Block: Build fix for allocation/congestion changes
Message-ID: <alpine.DEB.2.00.0904061811250.25143@parag-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

I don't know if you have pending patches to take care of the remaining 
users of BDI_{read/write}_congested - but meanwhile this patch allows me 
to build today's Linus git.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

--- linux-2.6/drivers/md/raid1.c	2009-04-06 17:37:25.609691615 -0400
+++ linux-2.6-wk/drivers/md/raid1.c	2009-04-06 18:10:55.058441747 -0400
@@ -586,7 +586,7 @@
 			/* Note the '|| 1' - when read_balance prefers
 			 * non-congested targets, it can be removed
 			 */
-			if ((bits & (1<<BDI_write_congested)) || 1)
+			if ((bits & (1<<BDI_async_congested)) || 1)
 				ret |= bdi_congested(&q->backing_dev_info, bits);
 			else
 				ret &= bdi_congested(&q->backing_dev_info, bits);

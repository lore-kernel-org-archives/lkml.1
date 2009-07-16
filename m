Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZGPHm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZGPHm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZGPHm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:42:28 -0400
Received: from gg.genua.de ([151.136.100.2]:31439 "EHLO gg.genua.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZGPHm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:42:27 -0400
From: Sten Spans <Sten_Spans@genua.de>
Date: Thu, 16 Jul 2009 09:41:39 +0200
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: security_file_lock cmd argument
Message-ID: <20090716074139.GB23769@false>
References: <alpine.LRH.2.00.0907092031020.4944@tundra.namei.org> <alpine.LRH.2.00.0907161003550.27259@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.00.0907161003550.27259@tundra.namei.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:05:47AM +1000, James Morris wrote:
> > From: Sten Spans <Sten_Spans@genua.de>
> 
> This looks good, but you need to add a signed-off-by line per 
> Documentation/SubmittingPatches
> 

Makes sense, how about:

Pass posix-translated lock operations to security_file_lock
when invoked via sys_flock.

Signed-off-by: Sten Spans <Sten_Spans@genua.de>

--- fs/locks.c.orig	2009-07-09 11:26:45.000000000 +0200
+++ fs/locks.c	2009-07-09 11:27:24.000000000 +0200
@@ -1590,7 +1590,7 @@
 	if (can_sleep)
 		lock->fl_flags |= FL_SLEEP;
 
-	error = security_file_lock(filp, cmd);
+	error = security_file_lock(filp, lock->fl_type);
 	if (error)
 		goto out_free;
 
-- 
GeNUA Gesellschaft für Netzwerk - und Unix-Administration mbH
Domagkstr. 7, D-85551 Kirchheim. http://www.genua.de
Tel: (089) 99 19 50-0, Fax: (089) 99 19 50 - 999
 
 Geschäftsführer: Dr. Magnus Harlander, Dr. Michaela Harlander,
 Bernhard Schneck. Amtsgericht München HRB 98238

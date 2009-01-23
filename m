Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZAWVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZAWVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 16:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZAWVP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 16:15:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:45843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZAWVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 16:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kqmleNQfxugSKuOpLYLC/7B61NbovwPQ/TbHPTICoIS7NK9blS/zrnsKEP6QF8qR13
         aXITMVpL0U9/SLtc+3LtuLmnFOW/jKpW0cUb04uC7ZhJBzDBiGvvBpfqqCodr341gpmz
         gdxZR3zVueNZI6UlJwP33cO3SeAcuczIySC90=
Date: Sat, 24 Jan 2009 00:21:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: linux-next: Tree for January 23 (drivers/watchdog/cpwd.c:411:
	error: 'inode' undeclared (first use in this function))
Message-ID: <20090123212126.GA4937@x200.localdomain>
References: <20090123184826.f2c91472.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123184826.f2c91472.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sparc:

drivers/watchdog/cpwd.c: In function 'cpwd_ioctl':
drivers/watchdog/cpwd.c:411: error: 'inode' undeclared (first use in this function)
drivers/watchdog/cpwd.c:411: error: (Each undeclared identifier is reported only once
drivers/watchdog/cpwd.c:411: error: for each function it appears in.)
drivers/watchdog/cpwd.c: In function 'cpwd_compat_ioctl':
drivers/watchdog/cpwd.c:483: warning: passing argument 1 of 'cpwd_ioctl' from incompatible pointer type
drivers/watchdog/cpwd.c:483: warning: passing argument 2 of 'cpwd_ioctl' makes integer from pointer without a cast
drivers/watchdog/cpwd.c:483: error: too many arguments to function 'cpwd_ioctl'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/watchdog/cpwd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -402,6 +402,7 @@ static int cpwd_release(struct inode *inode, struct file *file)
 
 static long cpwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	static struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
 		.firmware_version	= 1,
@@ -480,7 +481,7 @@ static long cpwd_compat_ioctl(struct file *file, unsigned int cmd,
 	case WIOCSTOP:
 	case WIOCGSTAT:
 		lock_kernel();
-		rval = cpwd_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		rval = cpwd_ioctl(file, cmd, arg);
 		unlock_kernel();
 		break;
 

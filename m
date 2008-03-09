Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYCIKts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYCIKts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYCIKtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:49:41 -0400
Received: from aun.it.uu.se ([130.238.12.36]:62365 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYCIKtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:49:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18387.49334.235230.751065@harpo.it.uu.se>
Date: Sun, 9 Mar 2008 11:49:26 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Mikael Pettersson <mikpe@it.uu.se>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark kobjects as unitialized
In-Reply-To: <200803091251.15428.balajirrao@gmail.com>
References: <200803062223.18857.balajirrao@gmail.com>
	<200803091206.02680.balajirrao@gmail.com>
	<20080309070307.GA6154@suse.de>
	<200803091251.15428.balajirrao@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balaji Rao writes:
 > Yes the idea works. One more memset is needed in sysdev_register. Here's the final patch.
 > 
 > diff --git a/drivers/base/sys.c b/drivers/base/sys.c
 > index 2f79c55..7c839d9 100644
 > --- a/drivers/base/sys.c
 > +++ b/drivers/base/sys.c
 > @@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 >         pr_debug("Registering sysdev class '%s'\n",
 >                  kobject_name(&cls->kset.kobj));
 >         INIT_LIST_HEAD(&cls->drivers);
 > +       memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
 >         cls->kset.kobj.parent = &system_kset->kobj;
 >         cls->kset.kobj.ktype = &ktype_sysdev_class;
 >         cls->kset.kobj.kset = system_kset;
 > @@ -227,6 +228,7 @@ int sysdev_register(struct sys_device * sysdev)
 >  
 >         pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
 >  
 > +       memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
 >         /* Make sure the kset is set */
 >         sysdev->kobj.kset = &cls->kset;
 > 

Thanks, 2.6.25-rc4 + these two memset()s is finally stable for
me with no warnings, BUG()s, or panics.

(However, the patch is whitespace damaged with initial tabs
converted to spaces.)

If you want to pass this on to Linus, you can add a

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

/Mikael

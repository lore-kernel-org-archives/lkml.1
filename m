Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYCJRYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYCJRYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYCJRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:23:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:33506 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbYCJRXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:23:55 -0400
Date: Mon, 10 Mar 2008 10:20:02 -0700
From: Greg KH <gregkh@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Balaji Rao <balajirrao@gmail.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark kobjects as unitialized
Message-ID: <20080310172002.GA28146@suse.de>
References: <200803062223.18857.balajirrao@gmail.com> <200803091206.02680.balajirrao@gmail.com> <20080309070307.GA6154@suse.de> <200803091251.15428.balajirrao@gmail.com> <18387.49334.235230.751065@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18387.49334.235230.751065@harpo.it.uu.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 11:49:26AM +0100, Mikael Pettersson wrote:
> Balaji Rao writes:
>  > Yes the idea works. One more memset is needed in sysdev_register. Here's the final patch.
>  > 
>  > diff --git a/drivers/base/sys.c b/drivers/base/sys.c
>  > index 2f79c55..7c839d9 100644
>  > --- a/drivers/base/sys.c
>  > +++ b/drivers/base/sys.c
>  > @@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_class * cls)
>  >         pr_debug("Registering sysdev class '%s'\n",
>  >                  kobject_name(&cls->kset.kobj));
>  >         INIT_LIST_HEAD(&cls->drivers);
>  > +       memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
>  >         cls->kset.kobj.parent = &system_kset->kobj;
>  >         cls->kset.kobj.ktype = &ktype_sysdev_class;
>  >         cls->kset.kobj.kset = system_kset;
>  > @@ -227,6 +228,7 @@ int sysdev_register(struct sys_device * sysdev)
>  >  
>  >         pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
>  >  
>  > +       memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
>  >         /* Make sure the kset is set */
>  >         sysdev->kobj.kset = &cls->kset;
>  > 
> 
> Thanks, 2.6.25-rc4 + these two memset()s is finally stable for
> me with no warnings, BUG()s, or panics.
> 
> (However, the patch is whitespace damaged with initial tabs
> converted to spaces.)
> 
> If you want to pass this on to Linus, you can add a
> 
> Tested-by: Mikael Pettersson <mikpe@it.uu.se>

Thanks for testing.

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXKIE5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXKIE5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXKIE5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:57:39 -0500
Received: from [212.12.190.251] ([212.12.190.251]:58261 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753190AbXKIE5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:57:38 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: Introduce rootdir bootparm to select which dir to sys_chroot
Date: Fri, 9 Nov 2007 07:57:10 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
References: <200711061340.26112.a1426z@gawab.com> <20071108203618.99741428.akpm@linux-foundation.org>
In-Reply-To: <20071108203618.99741428.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711090757.10190.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > On Tue, 6 Nov 2007 13:40:26 +0300 Al Boldi <a1426z@gawab.com> wrote:
> >
> > This patch introduces a rootdir kernel boot parameter, which specifies
> > the path to the kernel sys_chroot boot dir.
> >
> > This is useful for systems that have more than one distribution
> > installed on the same fs/partition.
> >
> >
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Al Boldi <a1426z@gawab.com>
> >
> > ---
> >
> > --- a/init/do_mounts.c
> > +++ b/init/do_mounts.c
> > @@ -252,6 +252,15 @@ __setup("rootflags=", root_data_setup);
> >  __setup("rootfstype=", fs_names_setup);
> >  __setup("rootdelay=", root_delay_setup);
> >
> > +static char * __initdata root_dir;
> > +static int __init root_dir_setup(char *str)
> > +{
> > +	root_dir = strcat("./",str);
> > +	return 1;
> > +}
> > +
> > +__setup("rootdir=", root_dir_setup);
>
> Please update Documentation/kernel-parameters.txt when adding __setup
> options.

Sure.

If you think this feature is useful, which I think it is, then I probably 
need to resend with a doc update.  But bare in mind, this patch needs 
something like small hack to allow remounting root, which currently isn't 
possible.  I'm sure hpa is probably the genius to help out here.

>
> >  static void __init get_fs_names(char *page)
> >  {
> >  	char *s = page;
> > @@ -469,6 +478,10 @@ void __init prepare_namespace(void)
> >  	mount_root();
> >  out:
> >  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
> > +
> > +	if(root_dir)
> > +		sys_chdir(root_dir);
> > +
>
> Please run scripts/checkpatch.pl across all patches before sending them to
> anyone.

Ok.


Thanks!

--
Al


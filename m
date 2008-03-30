Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYC3Uen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYC3Uen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYC3Ued
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:34:33 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:48647 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbYC3Ue3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:34:29 -0400
Date: Sun, 30 Mar 2008 23:34:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: wish: build time warning for missing MODULE_LICENSE
Message-ID: <20080330203417.GA7607@cs181133002.pp.htv.fi>
References: <20080330180119.GC1575@cs181133002.pp.htv.fi> <20080330190430.GD19733@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080330190430.GD19733@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 09:04:30PM +0200, Sam Ravnborg wrote:
> On Sun, Mar 30, 2008 at 09:01:19PM +0300, Adrian Bunk wrote:
> > I just fixed a bug where I had accidentally removed a MODULE_LICENSE() 
> > from a file.
> > 
> > The problem is that such bugs are currently not discovered until someone 
> > actually runs a kernel with this module loaded.
> > 
> > Could we get a build time warning/error for a missing MODULE_LICENSE?
> 
> Is it something as simple as this you are after?
> [My dev box is dead atm so I have not done a kernel build
> with this, only a single module].

Thanks, it seems to work - and I'm currently working on fixing the bugs 
it catches.

Considering that these are trivial to fix I'd even suggest a fatal() 
instead of the warn() for making them obvious for everyone doing build 
testing.

> 	Sam
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 695b5d6..e8560a0 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1552,6 +1552,8 @@ static void read_symbols(char *modname)
>  	}
>  
>  	license = get_modinfo(info.modinfo, info.modinfo_len, "license");
> +	if (!license && !is_vmlinux(modname))
> +		warn("modpost: missing MODULE_LICENSE() in %s\n", modname);
>  	while (license) {
>  		if (license_is_gpl_compatible(license))
>  			mod->gpl_compatible = 1;

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYEYGPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYEYGPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 02:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYEYGOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 02:14:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50414 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYEYGOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 02:14:49 -0400
Date: Sun, 25 May 2008 08:15:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: use defconfig as last resort
Message-ID: <20080525061525.GA30707@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <alpine.LFD.1.10.0805241320200.3081@woody.linux-foundation.org> <20080524203748.GA2343@uranus.ravnborg.org> <alpine.LFD.1.10.0805241825460.3081@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805241825460.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 06:30:40PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 24 May 2008, Sam Ravnborg wrote:
> > 
> > When using "make oldconfig" with no .config
> > present try the list from init/Kconfig DEFCONFIG_LIST
> > before resorting to use one of the defconfigs.
> 
> Hmm. Why does placement matter here?

We have the following list in init/Kconfig:

config DEFCONFIG_LIST
        string
        depends on !UML
        option defconfig_list
        default "/lib/modules/$UNAME_RELEASE/.config"
        default "/etc/kernel-config"
        default "/boot/config-$UNAME_RELEASE"
        default "arch/$ARCH/defconfig"

If we define an arch specific DEFCONFIG_LIST before this then
the arch supplied values are tried first.
The patch moves the ARCH supplied list below the definition
in init/Kconfig so it is tried last.

> 
> Also:
> 
> > +config DEFCONFIG_LIST
> > +	string
> > +	depends on X86_32
> > +	option defconfig_list
> > +	default "arch/x86/configs/i386_defconfig"
> > +
> > +config DEFCONFIG_LIST
> > +	string
> > +	depends on X86_64
> > +	option defconfig_list
> > +	default "arch/x86/configs/x86_64_defconfig"
> > +
> 
> Wouldn't this be cleaner as just *one* entry, and then just have 
> different default statements, ie something like

I will try to come up with an alternative solution in a minute.

	Sam

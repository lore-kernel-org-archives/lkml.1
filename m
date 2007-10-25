Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbXJYGOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbXJYGOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXJYGOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:14:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:46866 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbXJYGOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M0D9r5n483wIJdFvwWiGXFAxWHHjOJLjGf9kqCIjmsVFFX/zUtW+yz5g/jWoGDS7vg1IIuz0o14HVnq0SJ17Fggg8shjLuUE+hqajqZndoYQCjeCllvx0L6GjHA3mEJkyN5Ng1ohkZT+yp7p9NMRq05NIwDDhS92t4kVfi3RIe4=
Message-ID: <86802c440710242314i6e16b544g1e10f7af0f917cf9@mail.gmail.com>
Date: Wed, 24 Oct 2007 23:14:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20071024155043.04ba31cd.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <20071024080451.GA32690@infradead.org>
	 <20071024110733.GA1374@uranus.ravnborg.org>
	 <20071024121218.GA23548@elte.hu>
	 <20071024213052.GA5469@uranus.ravnborg.org>
	 <20071024155043.04ba31cd.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 24 Oct 2007 23:30:52 +0200 Sam Ravnborg wrote:
>
> > Hi Ingo.
> >
> > This is first step in getting rid of the two directories.
> > I had to do some very minor modifications in common files
> > to let it work out - but nothing really hackish.
> >
> > If you & Thomas + hpa are OK with the changes they can be
> > pulled from:
> >
> >       git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git
> >
> > As this is mostly renames I have attached a git -M diff only.
> >
> > The remaining stuff is Kconfig files.
> >
> > Before looking into these I am hoping someone could
> > step in and make the two Kconfig.debug
> > files 100% equal - because then I can fix the kconfig
> > stuff and finally kill the two directories.
>
> Uh, maybe I jumped too far.  I merged the 2 x86 Kconfig.debug files
> into arch/x86/Kconfig.debug....
>
> ---
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Merge i386/Kconfig.debug and x86_64/Kconfig.debug into x86/Kconfig.debug,
> using "depends on X86_32" or X86_64 when needed.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/i386/Kconfig.debug   |   88 ----------------------------------
>  arch/x86/Kconfig.debug    |  119 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86_64/Kconfig.debug |   61 -----------------------
>  3 files changed, 119 insertions(+), 149 deletions(-)
>
> --- linux-2.6.24-rc1.orig/arch/i386/Kconfig.debug
> +++ /dev/null
> @@ -1,88 +0,0 @@
> -menu "Kernel hacking"
> -
> -config TRACE_IRQFLAGS_SUPPORT
> -       bool
> -       default y
> -
> -source "lib/Kconfig.debug"
> -
> -config EARLY_PRINTK
> -       bool "Early printk" if EMBEDDED && DEBUG_KERNEL
> -       default y
> -       help
> -         Write kernel log output directly into the VGA buffer or to a serial
> -         port.
...
> --- /dev/null
> +++ linux-2.6.24-rc1/arch/x86/Kconfig.debug
> @@ -0,0 +1,119 @@
> +menu "Kernel hacking"
> +
> +config TRACE_IRQFLAGS_SUPPORT
> +       def_bool y
> +
> +source "lib/Kconfig.debug"
> +
> +config EARLY_PRINTK
> +       bool "Early printk" if EMBEDDED && DEBUG_KERNEL
> +       default y
> +       depends on X86_32
> +       help
> +         Write kernel log output directly into the VGA buffer or to a serial
> +         port.
> +
> +         This is useful for kernel debugging when your machine crashes very
> +         early before the console code is initialized. For normal operation
> +         it is not recommended because it looks ugly and doesn't cooperate
> +         with klogd/syslogd or the X server. You should normally N here,
> +         unless you want to debug such a crash.
> +
...
in x86_64/Kconfig has EARLY_PRINTK too

config EARLY_PRINTK
        bool
        default y


YH

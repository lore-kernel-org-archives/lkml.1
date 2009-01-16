Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbZAPLzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbZAPLzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbZAPLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:55:44 -0500
Received: from ports.donpac.ru ([80.254.111.81]:45531 "EHLO ports.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670AbZAPLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:55:43 -0500
X-Greylist: delayed 2206 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 06:55:43 EST
Date: Fri, 16 Jan 2009 14:18:13 +0300
From: Andrey Panin <pazke@donpac.ru>
To: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan-Benedict Glaw <jbglaw@lug-owl.de>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090116111813.GA3125@ports.donpac.ru>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jan-Benedict Glaw <jbglaw@lug-owl.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk> <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de> <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org> <20090115133252.28c36adb@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org> <20090115141734.GA15732@elte.hu> <20090116090002.GD4795@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116090002.GD4795@atrey.karlin.mff.cuni.cz>
X-Uname: Linux 2.6.18-4-powerpc64 ppc64
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 016, 01 16, 2009 at 10:00:02AM +0100, Pavel Machek wrote:
> > 
> > * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> > 
> > > On Thu, 15 Jan 2009, Alan Cox wrote:
> > > 
> > > > >  UP emulation of CMPXCHG and XADD for userland should be rather trivial, 
> > > > > so why not include it like with LL/SC for MIPS?
> > > > 
> > > > Why not just ship an additional libc with the right options ?
> > > 
> > >  Does not work for MIPS as glibc has no equivalent code for pre-LL/SC 
> > > CPUs and LL/SC is always used.  For the i386 the situation seems worse 
> > > yet as for pre-i486 CPUs a generic C implementation of 
> > > compare-and-exchange is used guaranteeing silent thread unsafety. :(
> > > 
> > >  IMO, a kernel emulation of CMPXCHG and XADD (both are used by 
> > > sysdeps/i386/i486/bits/atomic.h in glibc) with an optional LOCK prefix, 
> > > guaranteeing UP atomicity would be a cheap way to provide long-term i386 
> > > userland support with little burden for both Linux and respective user 
> > > software maintainers.  Certainly it adds some bloat to the kernel, but I 
> > > think it is not an option that should be outright dismissed without 
> > > consideration.
> > 
> > patches are welcome ...
> 
> Hehe, I guess the only long-term solution is to get shiny old 386 as a
> part of Ingo's test farm ;-).

It's not so difficult BTW, i386EX CPUs are still used in embedded world.
Example: http://www.embeddedarm.com/products/board-detail.php?product=TS-3300
It even has ethernet and price is reasonable (for embedded board of course) :)

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

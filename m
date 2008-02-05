Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYBEVFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYBEVFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbYBEVEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:04:52 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:12585 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbYBEVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Y6xsN4MnJIdco0yDeR46Xw5J1sjTuhl15EYQoPUTSOYZcgjyy3xBIW6s266/M6pQ4mDZ8XVc2v3ApkkM4a6YudsQ27SG29uJF1bPoCM3bGi4tLioCRiMODxn5nPjQovRO5GLkD9nkSSS1BNSLySGSz2zGIcDaaoh4iXYewV02Us=
Message-ID: <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com>
Date: Tue, 5 Feb 2008 16:04:47 -0500
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: T61P sound issue
Cc: "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080205102219.83fe459d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
	 <20080204194038.d8851b8d.akpm@linux-foundation.org>
	 <20080205113633.GI27738@hjernemadsen.org>
	 <20080205102219.83fe459d.akpm@linux-foundation.org>
X-Google-Sender-Auth: 38fd6269a9ff74d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 5, 2008 1:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 5 Feb 2008 12:36:33 +0100 "Klaus S. Madsen" <ksm@hjernemadsen.org> wrote:
>
> > On Mon, Feb 04, 2008 at 19:40:38 -0800, Andrew Morton wrote:
> > > On Sun, 27 Jan 2008 08:49:29 -0500 "Felipe Balbi" <felipebalbi@users.sourceforge.net> wrote:
> > >
> > > If a bug report fell in a forest, would ...
> > >
> > > > Hi all,
> > > >
> > > > Could anyone make T61P's ICH8 sound controller to work properly?
> > >
> > > ooh, a fellow t61p owner.  How's suspend and resume working?
> > I'm also a T61p owner, and for me suspend is working. I'm using Linux
> > 2.6.24 (32 bit version) and the newest driver from NVidia (yes, I know I
> > should be using the opensource driver, but it didn't work when I got my
> > laptop).
>
> 32-bit kernel?  hm.
>
> I use the xorg X11 driver.  It's slow but that's OK.
>
> > I haven't got hibernation working yet, but I haven't yet tried without
> > the NVidia module loaded (and as suspend works, hibernation isn't that
> > important for me).
>
> suspend-to-disk works for me but suspend-to-ram fails in various different
> ways depending on which kernel I'm running.
>
>
> > > > Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
> > > >
> > > > Running linux-2.6.24 stable. If there's a know bug, I could try to dig
> > > > more on it and get more info.
> > >
> > > It works for me.  http://userweb.kernel.org/~akpm/config-t61p.txt
> > Sound also works for me. Config at http://hogthrob.42.dk/config-t61p.txt
> >
> > > > Call Trace:
> > > >  <IRQ>  [<ffffffff80263b5f>] __report_bad_irq+0x30/0x72
> > > >  [<ffffffff80263dcb>] note_interrupt+0x22a/0x26b
> > > >  [<ffffffff8026463a>] handle_fasteoi_irq+0xa9/0xd0
> > > >  [<ffffffff8020e6cf>] do_IRQ+0x6c/0xd5
> > > >  [<ffffffff8020c411>] ret_from_intr+0x0/0xa
> > > >  [<ffffffff8021c1a4>] lapic_next_event+0x0/0xa
> > > >  [<ffffffff8023a692>] __do_softirq+0x5a/0xce
> > > >  [<ffffffff8024f060>] tick_program_event+0x31/0x4d
> > > >  [<ffffffff8020d08c>] call_softirq+0x1c/0x28
> > > >  [<ffffffff8020e4e0>] do_softirq+0x2c/0x7d
> > > >  [<ffffffff8023a5f3>] irq_exit+0x3f/0x84
> > > >  [<ffffffff8021c55c>] smp_apic_timer_interrupt+0x3f/0x53
> > > >  [<ffffffff8020cb36>] apic_timer_interrupt+0x66/0x70
> > > >  <EOI>
> > > > handlers:
> > > > [<ffffffff803fa647>] (usb_hcd_irq+0x0/0x52)
> > > > Disabling IRQ #19
> > > >
> > >
> > > (everyone gets this btw - some weird bluetooth-vs-usb thing which we don't
> > > know how to fix).
> > This is actually fixed by upgrading to the newest version of the BIOS.
> > I'm currently running version 7LETA7WW (2.07), and haven't seen the
> > problem since I upgraded.
>
> Interesting.  Maybe that'll change suspend-to-ram behaviour as well.
>

Good that there's a lot of people using T61p, it's a good machine.

About suspend/hibernate I didn't try yet cuz I'm using a crytofs due
to work needs :-p ehehehe

I'll upgrade my BIOS and try again the crappy sound.


BTW, I'm using T61p Type 6458 Model DE9.

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net

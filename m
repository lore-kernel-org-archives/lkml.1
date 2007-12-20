Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbXLTWEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbXLTWEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764015AbXLTWDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:03:55 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39456 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764003AbXLTWDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:03:53 -0500
Date: Thu, 20 Dec 2007 23:05:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071220220547.GA5641@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com> <20071220182815.GA5438@uranus.ravnborg.org> <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 04:27:37PM -0500, linux-os (Dick Johnson) wrote:
> 
> On Thu, 20 Dec 2007, Sam Ravnborg wrote:
> 
> >>
> >> It never gets to the printk(). You were right about the
> >> compilation. Somebody changed the kernel to compile with
> >> parameter passing in REGISTERS! This means that EVERYTHING
> >> needs to be compiled the same way, 'C' calling conventions
> >> were not good enough!
> >
> > How did you build the module. It reads like you failed to use
> > kbuild to build your module which is why you did not pass
> > correct options to gcc - correct?
> >
> > If you did not use kbuild - why not?
> > Is there anything missing you need?
> >
> > 	Sam
> >
> 
> I need to get rid of -mregparm=3 on gcc's command line. It
> is completely incompatible with the standard calling conventions
> used in all our assembly-language files in our drivers. We make
> very high-speed number-crunching drivers that munge high-speed
> data into images. We need to do that in assembly as we have
> always done.
That I understand. So you need a CONFIG_ option to switch off
-regparm=3 and pray that the kernel assembly supports it.

And then I assume you avoided kbuild because it added -regparm=3
which is why your simple module broke.

As you are well aware there is not any testing of a kernel without
-regparm=3 these days so you should strongly consider making your
assembly module comply with -regparm=3.

And no - I dunno how much work that is and what impact it has
on your number chrunching stuff.
But it looks like the only sane long-term solution to me.

	Sam

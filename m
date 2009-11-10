Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbZKJF6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbZKJF6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZKJF6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:58:34 -0500
Received: from 1wt.eu ([62.212.114.60]:50888 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZKJF6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:58:33 -0500
Date: Tue, 10 Nov 2009 06:58:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: Matteo Croce <technoboy85@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110055837.GB15338@1wt.eu>
References: <20091106155937.11d95279@lxorguk.ukuu.org.uk> <20091106165731.26800@gmx.net> <20091106182218.43940287@lxorguk.ukuu.org.uk> <20091106200620.179910@gmx.net> <m3r5sbcl07.fsf@intrepid.localdomain> <20091107000559.166710@gmx.net> <40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com> <20091108110512.3cfad100@mycelium.queued.net> <40101cc30911081022h33ac20d7od591a9bcdb739f04@mail.gmail.com> <20091108134759.51ca97fc@mycelium.queued.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108134759.51ca97fc@mycelium.queued.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 01:47:59PM -0500, Andres Salomon wrote:
> > Right, but what if is_geode_lx() is called befor the x86.id change
> > takes effect? Maybe something like this?
> > 
> > --- a/arch/x86/include/asm/geode.h 2009-11-08 19:13:43.531117343 +0100
> > +++ b/arch/x86/include/asm/geode.h      2009-11-08 19:19:42.130618023
> > +0100 @@ -177,7 +177,7 @@
> >  static inline int is_geode_lx(void)
> >  {
> >         return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
> > -               (boot_cpu_data.x86 == 5) &&
> > +               (boot_cpu_data.x86 == 5 || boot_cpu_data.x86 == 6) &&
> >                 (boot_cpu_data.x86_model == 10));
> >  }
> 
> 
> Yeah, that looks better.

Wouldn't it be even better if we didn't touch boot_cpu_data.x86
in the first place ? We can provide the emulation to support
686 binaries without faking the CPU family/model, I think it
would be cleaner. Otherwise we would need to report "real" and
"emulated" families in /proc...

Willy


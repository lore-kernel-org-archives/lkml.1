Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYAAVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYAAVCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYAAVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:02:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbYAAVCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:02:13 -0500
Date: Tue, 1 Jan 2008 22:01:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christer Weinigel <christer@weinigel.se>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101210143.GB759@elte.hu>
References: <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <20080101164338.GA901@elte.hu> <20080101183238.74307174@weinigel.se> <20080101184659.GA9250@elte.hu> <20080101203518.26e889f2@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101203518.26e889f2@weinigel.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christer Weinigel <christer@weinigel.se> wrote:

> On Tue, 1 Jan 2008 19:46:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Christer Weinigel <christer@weinigel.se> wrote:
> > 
> > > What I'm afraid is that udelay will be significantly slower, [...]
> > 
> > why should it be significantly slower?
> 
> out 80h, al is only two bytes.  Any alternative that has been 
> suggested in this discussion will use more space.  mov dx, alt_port; 
> out dx, al will be larger, a function call will definitely be a lot 
> larger. People have been making changes to the kernel to save a couple 
> of hundred bytes of text size.

i've done dozens of patches that saved much less of text size, so yes, i 
very much care about code size. But it has been stated in this thread 
that most of the _p() API uses in the kernel today are bogus. So 
eventually getting rid of the bogus ones will be a net code size 
_reduction_. (But even that is besides the point, we prefer clean and 
easier to maintain code.)

> I don't know if the difference in code size or the udelay will be 
> significantly slower, but I think it might be.

ok, "I dont know but it might be slower" is a perfectly fine statement 
instead of your original "it will be slower".

	Ingo

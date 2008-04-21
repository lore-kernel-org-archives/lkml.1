Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbYDUUEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbYDUUEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYDUUDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:03:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42259 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYDUUDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:03:54 -0400
Date: Mon, 21 Apr 2008 22:03:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421200330.GJ8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8FD6.3030700@zytor.com> <1208792559.3640.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208792559.3640.20.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > i ended up excluding Voyager configs from our test space some time 
> > > ago (and VISWS as well - there's one more visws fix in x86.git), 
> > > that's how this broke. These subarchitectures seem not to be used 
> > > at all and the code wont boot on normal PCs. We could mark it 
> > > BROKEN but the fix seems simple in any case.
> 
> I did actually try to avoid these problems by booting the -mc tree on 
> voyager, but I note that none of these issues showed up in that tree 
> the last time I did this (admittedly about 3 weeks ago because of 
> various conferences etc).

btw., any chance to turn it into a quirk space thing? Voyagers are 
almost-PCs, right? Most of the Voyager specialities appears to be 
abstracted away already via smp_ops. I.e. we could have Voyager support 
in a plain x86 kernel, if CONFIG_X86_VOYAGER is turned on.

quirks we can let survive almost forever - we've still got the math-emu 
code for example. It's the subarch code we'd like to eliminate 
eventually. (there are much better abstractions for achieving the same 
thing: quirks and the genapic code)

OTOH, i just had a look at it, and it seems a rather special thing - it 
tries to do like a PC but without actually being a PC. Almost as if it 
had no or just a little bit of BIOS - the whole Voyager kernel seems to 
run on the bare metal. Not much point in upsetting that code base i 
suspect.

let us know if you run into any difficulties with making it to boot 
again ... nothing truly fundamental should have changed to break it, 
other that this moving around of SMP code.

	Ingo

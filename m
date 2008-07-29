Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYG2HR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYG2HR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYG2HRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:17:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYG2HRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:17:19 -0400
Date: Tue, 29 Jul 2008 09:16:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] x86 cleanup: convert round_up() to roundup()
Message-ID: <20080729071659.GA23511@elte.hu>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com> <20080726133932.GB4401@elte.hu> <86802c440807282341g65c90f10gbdcf72beecdd0852@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807282341g65c90f10gbdcf72beecdd0852@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sat, Jul 26, 2008 at 6:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> >
> >> The x86 architecture declares its own round_up macro. But there is a
> >> generic one in <linux/kernel.h> which can also be used. This patchset
> >> replaces the x86 round_up() macro with the generic roundup() one where
> >> possible. The patches have been compile-tested for 32 and 64 bit and
> >> boot-tested for 64 bit. If we can fix the other places too we can get
> >> rid of the x86 specific round_up() in the future.
> >
> > applied to tip/x86/cleanups - thanks Joerg!
> >
> these patches looks like some backward, aka wrong direction.
> 
> #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> 
> #define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
> #define round_down(x, y) ((x) & ~((y) - 1))
> 
> round_up looks more efficient.

hm, does it ever make a difference to the compiled output?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbXLTWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbXLTWOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbXLTWO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:14:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58056 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbXLTWO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:14:27 -0500
Date: Thu, 20 Dec 2007 23:13:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Newall <david@davidnewall.com>,
       "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>,
       Scott <linux-kernel@bluecamel.eml.cc>, linux-kernel@vger.kernel.org,
       hugh@veritas.com, stefanr@s5r6.in-berlin.de
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
	well
Message-ID: <20071220221357.GA27851@elte.hu>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200313.54425.volker.armin.hemmann@tu-clausthal.de> <1198122641.8341.1.camel@oasis.donpoo.home> <200712200653.28996.volker.armin.hemmann@tu-clausthal.de> <476A7E7E.7030704@davidnewall.com> <84144f020712201348k117b7db5x6ab71de796bdee5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712201348k117b7db5x6ab71de796bdee5b@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Nah, it's just that vma->anon_vma is probably supposed to be NULL 
> here. And if you look at all the oopses, they do suggest one 
> particular byte lane is dodgy (the corruption is in bits 41-43 and 
> 45).
> 
> The whole thing reminds me of another bug where memtest86 didn't find 
> anything because it's doing cached memory accesses: 
> http://lkml.org/lkml/2007/10/3/259

memtest86+ has an uncached test:

const struct tseq tseq[] = {
        {1,  5,  3,   0, 0, "[Address test, walking ones]          "},
        {1,  6,  3,   2, 0, "[Address test, own address]           "},
        {1,  0,  3,  14, 0, "[Moving inversions, ones & zeros]     "},
        {1,  1,  2,  80, 0, "[Moving inversions, 8 bit pattern]    "},
        {1, 10, 60, 300, 0, "[Moving inversions, random pattern]   "},
        {1,  7, 64,  66, 0, "[Block move, 64 moves]                "},
        {1,  2,  2, 320, 0, "[Moving inversions, 32 bit pattern]   "},
        {1,  9, 40, 120, 0, "[Random number sequence]              "},
        {1,  3,  4, 240, 0, "[Modulo 20, ones & zeros]             "},
        {1,  8,  1,   2, 0, "[Bit fade test, 90 min, 2 patterns]   "},
        {0,  4,  3,   2, 0, "[[Moving inversions, 0 & 1, uncached] "},
        {0,  0,  0,   0, 0, NULL}
};

find that "Moving inversions, 0 & 1" test and run that one alone, 
overnight.

	Ingo

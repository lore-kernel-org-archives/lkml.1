Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZFIPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZFIPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZFIPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:16:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZFIPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:16:03 -0400
Date: Tue, 9 Jun 2009 17:15:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
Message-ID: <20090609151557.GA9362@elte.hu>
References: <20090609082931.GD25316@prithivi.gnumonks.org> <1244537598.2558.9.camel@ht.satnam> <20090609145305.GD3986@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609145305.GD3986@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harald Welte <HaraldWelte@viatech.com> wrote:

> Thanks for your quick response.
> 
> On Tue, Jun 09, 2009 at 02:23:18PM +0530, Jaswinder Singh Rajput wrote:
>  
> > On Tue, 2009-06-09 at 16:29 +0800, Harald Welte wrote:
> > > This patch adds the MSR definitions for the VIA/Centaur CPU models
> > > to cpu_debug.c
> > > 
> > > Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> > 
> > As per Ingo suggestion, we removed model information from cpu_debug and
> > is available in -tip :
> 
> but what happens if one MSR has a different group from vendor A to 
> vendor B? [...]

MSRs should really be enumerated along CPU features. They will be 
accessed if a CPU offers that CPU feature.

> [...] and what happens if you read MSR's on a CPU that doesn't 
> have them?  I suppose you get a segmentation fault, at least 
> that's what I've received in the past when accidentially reading a 
> MSR that doesn't exist.  Is that what the _safe_ variant of rdmsr 
> is for?

Yeah, the safe read should never fault - there should be all zeroes 
or an error return.

	Ingo

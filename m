Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZKLINY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZKLINY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZKLINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:13:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZKLINX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:13:23 -0500
Date: Thu, 12 Nov 2009 09:13:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Message-ID: <20091112081317.GB25345@elte.hu>
References: <200911112134.34261.bzolnier@gmail.com>
 <20091112065930.GA9279@elte.hu>
 <4AFBB45A.9000606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFBB45A.9000606@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/11/2009 10:59 PM, Ingo Molnar wrote:
> > 
> > * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> >> "ht" flag indicates only ability to detect siblings not HT presence 
> >> itself.
> >>
> >> Inspired by:
> >> http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
> > 
> > i think instead of changing 'ht' to 'ht_detect', it would be even 
> > more intuitive to only expose the 'ht' flag if the ht-detect 
> > capability is there _and_ if the number of siblings is 2 or more.
> > 
> > That way we dont change it - we just 'hide' the 'ht' string on the 
> > category of systems that can enumerate HT via the CPUID but dont 
> > actually have HyperThreading.
> 
> /proc/cpuinfo is a user-space visible ABI.  Changing it is bad 
> chicken.

Almost ... something is only an ABI if an actual application relies on 
the 'ht' flag being there on non-hyperthreading CPUs. We dont know 
whether there's any, but the likelyhood looks pretty low. Could park it 
a branch for some time to see whether anything trips up.

	Ingo

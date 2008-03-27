Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYC0P1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYC0P1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 11:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYC0P04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 11:26:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbYC0P0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 11:26:55 -0400
Date: Thu, 27 Mar 2008 16:26:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
	dereference
Message-ID: <20080327152609.GA5406@elte.hu>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 25 Mar 2008, Andrew Morton wrote:
> > > Code: 53 c0 e8 20 08 fc ff c1 e3 02 8b 14 33 89 54 24 20 8b 44 24 20 85 c0 75 10 eb 51 8b 12 89 54 24 20 8b 44 24 20 85 c0 74 43 8b 02 <0f> 18 00 90 8d 5a d8 39 6b 34 75 e4 8b 7c 24 0c 39 7b 30 75 db 
> 
> It faults in a prefetch.
> 
> > Markus reported what looks to be the same thing here:
> > http://lkml.org/lkml/2008/3/21/202 and it's already in the regresison list.
> 
> Same here. And both are AMD X2 early stepping machines.
>  
> > I guess you've confirmed that this wasn't a mystery
> > once-off-on-that-machine.
> > 
> > I can't think what we did to cause this.
> 
> I had a lengthy bug decoding session with Ingo and we found the root
> cause:
> 
> A dropped workaround for the prefetch bug in early X2s and
> Opterons. Patch below.

can also be tested by picking up x86.git/latest, which has this patch 
included:

   http://people.redhat.com/mingo/x86.git/README

	Ingo

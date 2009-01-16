Return-Path: <linux-kernel-owner+w=401wt.eu-S938028AbZAPWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938028AbZAPWas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937832AbZAPWaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:30:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937164AbZAPWaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:30:23 -0500
Date: Fri, 16 Jan 2009 23:30:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
Message-ID: <20090116223011.GB3899@elte.hu>
References: <49704DF6.8040205@sgi.com> <20090116092540.GC4305@elte.hu> <4970C984.30202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970C984.30202@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Hi Ingo,
> 
> I did notice that the versions all came up the same, and that the checks 
> were very specific.  I was trying to be as transparent and unintrusive 
> as possible.  Since there's so few calls, I though this was a good 
> approach but apparently I was wrong.
> 
> I like the idea of collapsing the array down to one and checking to see 
> if all apic's have the same version, but is this really the case? Must 
> all apics be the same?

Could you please send a patch that doesnt change the code, only adds a 
'boot APIC version' kind of variable as an apic_version __read_mostly 
variable and does a WARN_ONCE() if that mismatches? We can then stick that 
into -tip and see whether it triggers.

The max array size is ~128K, right? So if the WARN_ONCE() does not 
trigger, we can just drop the array and use the central apic_version 
variable ...

And even if it _does_ trigger, the version incompatibilities between APIC 
protocols are very rare. They only happen across wildly different CPU 
architectures like when going from very old external apics to integrated 
apics, or going from apics to x-apics. We wont see any mixing across those 
boundaries.

	Ingo

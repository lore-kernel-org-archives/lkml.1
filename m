Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZBSUcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZBSUcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZBSUch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:32:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZBSUcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:32:36 -0500
Date: Thu, 19 Feb 2009 21:32:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
Message-ID: <20090219203221.GA10782@elte.hu>
References: <1235068713.15053.99.camel@nathan.suse.cz> <20090219185935.GA21820@elte.hu> <499DC13C.2000401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DC13C.2000401@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>
>> the problem is that the DO_BUG() will generate the u2d instruction into 
>> a random place where GCC puts it. It certainly wont be in the place 
>> where the __bug_table logic above expects it.
>>
>> The result will be cryptic crashes instead of a clean BUG message 
>> assert.
>>
>
> I went and talked to H.J. Lu about this.
>
> He said __builtin_trap(); is functionally treated as an asm volatile,  
> and that it is most likely impossible that gcc could do anything wrong  
> here (he did specifically state that nothing can move across the asm  
> volatile, and there are no data dependencies between the asm volatile  
> and the __builtin_trap).
>
> He also agreed that the right way to do this is __builtin_not_reached(),  
> and I promised to submit a feature request for this for a future version  
> of gcc.
>
> Given that, I would suggest we back out the patch, and that when  
> __builtin_not_reached(); is supported, we can simply do:
>
> #if __GNUC__ is recent enough
> # define not_reached() __builtin_not_reached()
> #else
> # define not_reached() for(;;)
> #endif
>
> OK?

Yeah, sounds good!

	Ingo

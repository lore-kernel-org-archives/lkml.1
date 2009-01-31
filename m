Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZAaAvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZAaAvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZAaAvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:51:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZAaAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:51:01 -0500
Date: Sat, 31 Jan 2009 01:50:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Hicks <mort@sgi.com>, tglx@linutronix.de, mingo@redhat.com,
       heukelum@mailshack.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
Message-ID: <20090131005047.GA21022@elte.hu>
References: <20090130165053.GE7872@alcatraz.americas.sgi.com> <49838F39.6060603@zytor.com> <49839CC8.7060502@zytor.com> <20090131003921.GA13709@elte.hu> <49839FB6.1080509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49839FB6.1080509@zytor.com>
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
>> Would be nice to have an #ifdef-less primitive for this - something like:
>>
>> 	pushq_frame %rbp
>>
>> and a matching:
>>
>> 	popq_frame %rbp
>>
>> for those cases that need it (this one doesnt as we dont pop out of the 
>> stack).
>>
>
> It certainly would if this isn't a singleton, which I think it could 
> possibly be?

yeah. This is pretty much the only non-restored frame we construct so 
indeed it would be a singleton. Perhaps the IST ones are such ones too.

> Otherwise it really should be a part of an entry/exit macro; this is 
> somewhat special in that it sets up a frame pointer as something other 
> than a normal entry/exit sequence.

Sure - your call really.

	Ingo

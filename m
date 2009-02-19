Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZBSQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZBSQl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZBSQlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:41:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbZBSQlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:41:17 -0500
Date: Thu, 19 Feb 2009 17:41:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Petr Tesarik <ptesarik@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Definition of BUG on x86
Message-ID: <20090219164104.GA20941@elte.hu>
References: <20090219122211.GE1703@elte.hu> <1235047082.15053.49.camel@nathan.suse.cz> <20090219124702.GC22044@elte.hu> <1235048535.15053.52.camel@nathan.suse.cz> <20090219144902.GA8650@elte.hu> <499D7B9D.7060001@goop.org> <20090219153544.GA31637@elte.hu> <1235059883.15053.68.camel@nathan.suse.cz> <20090219161649.GC9556@elte.hu> <499D8A0C.5030908@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499D8A0C.5030908@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Well, the important question is thatGCC will optimize out whatever 
>> comes after the __builtin_trap(), right? To guarantee an assert we can 
>> do something like:
>>
>>  	__builtin_trap();
>> 	panic("should never get here");
>>
>> to guarantee a message. (But realistically GCC will at most generate a 
>> build error.)
>
> Ah, right, I remember the problem.  There's no guaranteed way 
> of getting the address of the ud2a instruction __builtin_trap 
> generates to put it into the bug table.

hm, indeed.

So that 2 byte overhead will be there for now, until gcc (or 
some other compiler) is improved.

	Ingo

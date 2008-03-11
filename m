Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbYCKVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbYCKVTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYCKVTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:19:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:53373 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYCKVTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:19:12 -0400
In-Reply-To: <je1w6hc6yw.fsf@sykes.suse.de>
References: <1205254569.22317.8.camel@brick> <8d55c7ae2d3c851013db4857506b537c@kernel.crashing.org> <je1w6hc6yw.fsf@sykes.suse.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5116e96e09f6fc82587283a2a0cdd8ff@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] bitops: add 8-bit and 16-bit rotation functions
Date: Tue, 11 Mar 2008 22:18:27 +0100
To: Andreas Schwab <schwab@suse.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +/**
>>> + * rol16 - rotate a 16-bit value left
>>> + * @word: value to rotate
>>> + * @shift: bits to roll
>>> + */
>>> +static inline __u16 rol16(__u16 word, unsigned int shift)
>>> +{
>>> +	return (word << shift) | (word >> (16 - shift));
>>> +}
>>
>> This doesn't work for shift values of 0: you get word >> 16, and
>> shifts greater than or equal to the word size aren't valid C.  GCC
>> will warn about this, too.
>
> On the other hand, a value narrower than int will always be promoted
> first,

Erm, yes of course.  It is promoted to _signed_ int though, but
that works okay here.

> so this is not a problem in this case.

It still needs documentation for the valid values of "shift".


Segher


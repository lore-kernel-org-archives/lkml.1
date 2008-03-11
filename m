Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYCKU7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYCKU7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYCKU7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:59:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:35483 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYCKU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:59:41 -0400
From: Andreas Schwab <schwab@suse.de>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bitops: add 8-bit and 16-bit rotation functions
References: <1205254569.22317.8.camel@brick>
	<8d55c7ae2d3c851013db4857506b537c@kernel.crashing.org>
X-Yow: I'm totally DESPONDENT over the LIBYAN situation and the price of CHICKEN..
Date: Tue, 11 Mar 2008 21:59:35 +0100
In-Reply-To: <8d55c7ae2d3c851013db4857506b537c@kernel.crashing.org> (Segher
	Boessenkool's message of "Tue\, 11 Mar 2008 21\:45\:36 +0100")
Message-ID: <je1w6hc6yw.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool <segher@kernel.crashing.org> writes:

>> +/**
>> + * rol16 - rotate a 16-bit value left
>> + * @word: value to rotate
>> + * @shift: bits to roll
>> + */
>> +static inline __u16 rol16(__u16 word, unsigned int shift)
>> +{
>> +	return (word << shift) | (word >> (16 - shift));
>> +}
>
> This doesn't work for shift values of 0: you get word >> 16, and
> shifts greater than or equal to the word size aren't valid C.  GCC
> will warn about this, too.

On the other hand, a value narrower than int will always be promoted
first, so this is not a problem in this case.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

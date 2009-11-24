Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbZKXS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbZKXS7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbZKXS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:59:23 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:55660 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbZKXS7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=biVw2eWuhCbjnRP5zJrrtfwZ1GbAmJFhIfWvvKnAKYZlcDch3/dDFWK5DJgzA7XSJN
         BEG/NQjQVtGXMfU8OXCqSCuc9uwb+mVeusLj8feKyyr78kPPBvK9lS3W1lmengGGIIgF
         vyrIpw5suSYQsXNHC+xJFk7BoitGVftRP3qF4=
MIME-Version: 1.0
In-Reply-To: <727e50150911241017h4bb1c0aex800e8c0ef7eee9fd@mail.gmail.com>
References: <4B0BBB83.2020604@klingt.org>
	 <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
	 <727e50150911241017h4bb1c0aex800e8c0ef7eee9fd@mail.gmail.com>
Date: Tue, 24 Nov 2009 13:59:27 -0500
Message-ID: <73c1f2160911241059v66f89a3ep693e6967c3c5b8b3@mail.gmail.com>
Subject: Re: [PATCH 0/5] branch hint tweaks
From: Brian Gerst <brgerst@gmail.com>
To: aaron@assonance.org
Cc: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 1:17 PM, Aaron Cohen <remleduff@gmail.com> wrote:
> On Tue, Nov 24, 2009 at 12:50 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> On Tue, Nov 24, 2009 at 5:54 AM, Tim Blechmann <tim@klingt.org> wrote:
>>> hi all,
>>>
>>> doing some branch hint profiling of 2.6.31 on my nehalem machine showed
>>> a few
>>> incorrect branch hints.
>>> these patches remove or change the branch hints
>>
>> I'm not sure what version of GCC added this, but I wonder if this
>> option will fix the problem:
>>
>> -fno-guess-branch-probability
>>    Do not guess branch probabilities using heuristics.
>>
>>    GCC will use heuristics to guess branch probabilities if they are
>> not provided by profiling feedback (-fprofile-arcs). These heuristics
>> are based on the control flow graph. If some branch probabilities are
>
> Is the kernel's use of unlikely typically intended to mean "I consider
> the following unlikely so please optimize with that expectation" or is
> meant to indicate "the following is a slow-path so please pessimize
> it" or both?
>

Both.  It is meant to optimize static branch prediction (on x86,
forward branches are by default predicted not taken), and to reduce
icache footprint of infrequently used code in the main execution path.
 If a section of code is marked unlikely(), GCC should put the code at
the end of the function.

--
Brian Gerst

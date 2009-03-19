Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZCSUVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZCSUVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZCSUU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:20:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49634 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZCSUUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V8S2LeLkgaQ2oT6l+hB7HiVmgoizQU9fWMJJHwXjwvxDlOdcdlP5cQXbdST3g0Wo02
         vkht6dLybieshKeBFEDUP2JBx8O27svK3DU5UFt50Lmcf6qsqJBoOlYgCZhEjtiCphuG
         O9vvAPaCIfXUnhlqcFBcoSvzQFsHxntStdGTs=
MIME-Version: 1.0
In-Reply-To: <20090319192758.GB24318@elte.hu>
References: <20090319175544.13691.42362.stgit@f10box.hanneseder.net>
	 <20090319182628.GB28946@ZenIV.linux.org.uk>
	 <154e089b0903191151q37ab7b20o43838845af12966f@mail.gmail.com>
	 <20090319190730.GC28946@ZenIV.linux.org.uk>
	 <20090319192758.GB24318@elte.hu>
Date: Thu, 19 Mar 2009 21:20:51 +0100
Message-ID: <19f34abd0903191320qdd73530ud85081d23e17b266@mail.gmail.com>
Subject: Re: Nasal demons in preprocessor use (Re: [PATCH] test-suite: new 
	preprocessor test case)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
       linux-sparse@vger.kernel.org, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/19 Ingo Molnar <mingo@elte.hu>:
>
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
>> On Thu, Mar 19, 2009 at 07:51:22PM +0100, Hannes Eder wrote:
>> > When currently running sparse agains the current linux-next tree, a
>> > lot of checks produce error messages like this:
>> >
>> > include/linux/skbuff.h:381:9: error: expected preprocessor identifier
>>
>> Cute.  If anything, this kmemcheck_define_bitfield stuff needs to be moved
>> inside the ifdefs.
>>
>> Folks, this is not a valid C, period.  And no, there's no promise
>> that gcc won't change its behaviour on such constructs whenever
>> they feel like that.
>>
>> Preprocessor directives do not belong in argument lists.  Not
>> #ifdef, not #define, not #include; this is undefined behaviour.
>
> Agreed.
>
> Vegard, it's this bit:
>
>        kmemcheck_define_bitfield(flags2, {
> #ifdef CONFIG_IPV6_NDISC_NODETYPE
>                __u8                    ndisc_nodetype:2;
> #endif
> #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
>                __u8                    do_not_encrypt:1;
>                __u8                    requeue:1;
> #endif
>        });
>
>        Ingo
>

Hm.

Is this really not valid C?

It worked with GCC, so I assumed it was. My mistake.

Okay, that puts us in a bit of a tight spot, with regards to kmemcheck, I mean.

Maybe I should just take up GCC development instead, and implement a
-fkmemcheck or something.

(To get rid of the bitfield false positives, I mean.)

I guess this means that kmemcheck branch should be withdrawn from
linux-next, at least temporarily, as I have no immediate
workarounds/alternatives. Stephen, can you drop it?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbXBSMRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbXBSMRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXBSMRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:17:24 -0500
Received: from javad.com ([216.122.176.236]:2417 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbXBSMRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:17:23 -0500
From: Sergei Organov <osv@javad.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?utf-8?B?Si5BLiBN?= =?utf-8?B?YWdhbGzDg8ODw4PDgsKzbg==?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <7Mj5f-3oz-21@gated-at.bofh.it> <7MktH-5EW-35@gated-at.bofh.it>
	<7Mmvy-vj-17@gated-at.bofh.it> <7MnBC-2fk-13@gated-at.bofh.it>
	<7MoQx-4p8-11@gated-at.bofh.it> <7MpjE-50z-7@gated-at.bofh.it>
	<7MpCS-5Fe-9@gated-at.bofh.it> <7MDd7-17w-1@gated-at.bofh.it>
	<7MGkB-62k-31@gated-at.bofh.it> <7NHoe-2Mb-37@gated-at.bofh.it>
	<7NMe9-1ZN-7@gated-at.bofh.it> <7Oagl-6bO-1@gated-at.bofh.it>
	<7ObvW-89N-23@gated-at.bofh.it> <7Oc8t-NS-1@gated-at.bofh.it>
	<E1HHmuB-0001lW-E1@be1.lrz> <87zm7ei836.fsf@javad.com>
	<Pine.LNX.4.58.0702161553050.2481@be1.lrz>
Date: Mon, 19 Feb 2007 15:17:03 +0300
In-Reply-To: <Pine.LNX.4.58.0702161553050.2481@be1.lrz> (Bodo Eggert's
 message
	of "Fri, 16 Feb 2007 18:40:02 +0100 (CET)")
Message-ID: <87ejomgx4w.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:
> On Fri, 16 Feb 2007, Sergei Organov wrote:

[...]

> I'll say it again: Either the code using unspecified chars is correct, or 
> it isn't. If it's correct, neither using with signed nor with unsigned 
> chars is a bug and you should not warn at all, and if it's not correct, 
> you should always warn. Instead, gcc warns on "code compiles for
> $arch".

Here is where we disagree. In my opinion, no matter what the sign of
char for given architecture is, it's incorrect to pass either "signed
char*" or "unsigned char*" argument to a function expecting "char*".

>> > Therefore it's either always wrong to call your char* function with char*,
>> > unsigned char* _and_ signed char unless you can guarantee not to overflow any
>> > of them, or it's always correct to call char* functions with any kind
>> > of these.
>> 
>> How are you sure those who wrote foo(char*) agrees with your opinion or
>> even understands all the involved issues?
>
> Let's asume we have this piece of buggy code. We compile it on an unsigned
> char architecture. No warning. *BOOM*

There should be warning, -- that's my point. "char" is different. "char"
is distinct from either "signed char" or "unsigned char". Always. At
least it's how C is defined.

> Let's asume there is correct code, and we use it as designed:
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: real issue 
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: Wrong arch
> <scroll off screen/>
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: Wrong arch
> Warning: Wrong arch
>
> You don't see "real issue". *BOOM*
>
>
> What can you do about this warning? Let's asume we cast everywhere:

I already gave an answer in response to Linus:

static inline size_t ustrlen(const unsigned char *s)
{
    return strlen((const char *)s);
}

>
> struct foo * p;
> printf(strlen(char*)p); *BOOM*

printf(ustrlen(p)); *NO BOOM*
unsigned char* u;
printf(ustrlen(u)); *NO WARNING*

-- Sergei.

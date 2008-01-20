Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYATQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYATQYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYATQYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:24:07 -0500
Received: from saeurebad.de ([85.214.36.134]:38411 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYATQYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:24:06 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jeff Garzik" <jeff@garzik.org>,
       "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 2/6] typesafe: kthread_create and kthread_run
References: <200801202046.14746.rusty@rustcorp.com.au>
	<200801202047.22943.rusty@rustcorp.com.au>
	<200801202048.34796.rusty@rustcorp.com.au>
	<Pine.LNX.4.64.0801201223590.14598@fbirervta.pbzchgretzou.qr>
	<36ca99e90801200407h384106f7pc1ce37e8b34ad7ec@mail.gmail.com>
Date: Sun, 20 Jan 2008 17:24:42 +0100
In-Reply-To: <36ca99e90801200407h384106f7pc1ce37e8b34ad7ec@mail.gmail.com>
	(Bert Wesarg's message of "Sun, 20 Jan 2008 13:07:17 +0100")
Message-ID: <87ve5otqgl.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Bert Wesarg" <bert.wesarg@googlemail.com> writes:

> On Jan 20, 2008 12:25 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>>
>> On Jan 20 2008 20:48, Rusty Russell wrote:
>> >+ */
>> >+#define kthread_create(threadfn, data, namefmt...) ({         \
>> >+      int (*_threadfn)(typeof(data)) = (threadfn);            \
>> >+      __kthread_create((void *)_threadfn, (data), namefmt);   \
>> >+})
>>
>> If you have namefmt... you need that varagrs cpp trick. IIRC:
>>
>>         __kthread_create((void *)_threadfn, (data), namefmt, __VA_ARGS__);
> almost
>
> either:
>
> #define kthread_create(threadfn, data, ...) ({         \
>         __kthread_create((void *)_threadfn, (data), __VA_ARGS__);
>

No.  This is bad because it gives the impression that it takes only two
essential arguments which is not the case.

> or:
>
> #define kthread_create(threadfn, data, namefmt, ...) ({         \
>         __kthread_create((void *)_threadfn, (data), namefmt, ##__VA_ARGS__);
>

This is better.  I prefer naming the rest args instead of using __VA_ARGS__:

#define kthread_create(threadfn, data, namefmt, fmtargs...) ({ \
	... \
	__kthread_create((void *)_threadfn, (data), namefmt, ##	fmtargs) \
})

but I think that is just a matter of taste.

	Hannes

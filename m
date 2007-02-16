Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXBPMqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXBPMqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbXBPMqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:46:34 -0500
Received: from javad.com ([216.122.176.236]:3136 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXBPMqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:46:33 -0500
From: Sergei Organov <osv@javad.com>
To: 7eggert@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J.A. =?utf-8?B?TWFn?= =?utf-8?B?YWxsw4PDg8ODw4LCs24=?=" 
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
	<E1HHmuB-0001lW-E1@be1.lrz>
Date: Fri, 16 Feb 2007 15:46:05 +0300
In-Reply-To: <E1HHmuB-0001lW-E1@be1.lrz> (Bodo Eggert's message of "Thu, 15
	Feb 2007 21:08:35 +0100")
Message-ID: <87zm7ei836.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> Sergei Organov <osv@javad.com> wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>>> Exactly because "char" *by*definition* is "indeterminate sign" as far as
>>> something like "strlen()" is concerned.
>> 
>> Thanks, I now understand that you either don't see the difference
>> between "indeterminate" and "implementation-defined" in this context or
>> consider it non-essential, so I think I've got your point.
>
> If you don't code for a specific compiler with specific settings, there is
> no implementation defining the signedness of char, and each part of the code
> using char* will be wrong unless it handles both cases correctly.

The problem here is that due to historical reasons, there could be code
out there that abuses "char" for "signed char" (not sure about "unsigned
char"). Old code and old habits are rather persistent.

> Therefore it's either always wrong to call your char* function with char*,
> unsigned char* _and_ signed char unless you can guarantee not to overflow any
> of them, or it's always correct to call char* functions with any kind
> of these.

How are you sure those who wrote foo(char*) agrees with your opinion or
even understands all the involved issues?

> Off cause if you happen to code for specific compiler settings, one signedness
> of char will become real and one warning will be legit. And if pigs fly, they
> should wear googles to protect their eyes ...

And if people were writing perfect portable code all the time, there
would be no need for warnings in the first place...

-- Sergei.

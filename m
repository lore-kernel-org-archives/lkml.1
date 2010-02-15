Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0BOU2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:28:51 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:40379 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0BOU2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bxGauzbgO1KnhGe5jqBOitwqOcK5ZcamDwZgjX3gzo4shAn6nbkIdMebKfNzcnTpM2
         e0I/t4k1l4KdhahsQTpYrNHEalYfdCCdrVqvP2lciM17FLvWYFMAVIBJlV97nkRGME7d
         zE6VK+x6THPw0tqijD+0AzvvSYz7Y55vIW55c=
MIME-Version: 1.0
In-Reply-To: <20100215193948.GA28419@redhat.com>
References: <1266214553-29476-1-git-send-email-vapier@gentoo.org> 
	<20100215193948.GA28419@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 15 Feb 2010 15:28:29 -0500
Message-ID: <8bd0f97a1002151228r2a589047gddc1d998d52c969c@mail.gmail.com>
Subject: Re: [PATCH] tracehook: add some self tests
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 14:39, Oleg Nesterov wrote:
> On 02/15, Mike Frysinger wrote:
>> +static int __init syscall_test(void)
>> +{
>> +     struct pt_regs _regs, *regs = &_regs;
>> +     long _args[8];
>> +     long *args = _args + 1;
>> +     long *sys_args[6], *sa;
>> +     unsigned int i, n, s;
>> +
>> +     /*
>> +      * First find each system register in pt_regs.  We have to assume
>> +      * syscall_set_arguments() works with very basic arguments.
>> +      */
>> +     pr_info("TEST: asm/syscall.h: arg offsets: { ");
>> +
>> +     for (s = 0; s < 6; ++s)
>> +             args[s] = s;
>> +     memset(regs, 0xad, sizeof(*regs));
>> +     syscall_set_arguments(NULL, regs, 0, 6, args);
>                              ^^^^
>
> I am not sure ia64 can tolerate task == NULL. Hmm, even x86 checks
> task_thread_info(task)->status.

is there some task available while the kernel is initializing ?  i.e.
the test is compiled in ?

if current is valid, i'll just [ab]use that ...
-mike

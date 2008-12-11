Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYLKEoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYLKEoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYLKEn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:43:57 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:27508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYLKEn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b6ET/tqiu/fMPGOs0rrJrKkt9cw3vzHajs2Qq/l4TabNYEJoZmHtiQAe4oaATRv1cl
         rzWVcbZCP+qZJSmsiujJ3Xsq8IgWHmmqqSRWEOI1OeLKvCUfCHKAhjo/5H/OacwH0iO+
         a7Y9yddqCg+xS6B3KkP38Z+LMN/JfdrCDBSu4=
Message-ID: <9cde8bff0812102043w43ee18b5y7f3ed50b99736891@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:43:55 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: "Jianjun Kong" <jianjun@zeuux.org>
Subject: Re: [PATCH] fix calls to request_module()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
In-Reply-To: <20081211044017.GA7266@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	 <20081211040118.GK28946@ZenIV.linux.org.uk>
	 <20081210201455.0c611484.akpm@linux-foundation.org>
	 <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com>
	 <20081211044017.GA7266@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 1:40 PM, Jianjun Kong <jianjun@zeuux.org> wrote:
>
> * Nguyen Anh Quynh wrote:
>
>>On Thu, Dec 11, 2008 at 1:14 PM, Andrew Morton
>><akpm@linux-foundation.org> wrote:
>>> On Thu, 11 Dec 2008 04:01:18 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
>>>> > The request_module() function should always have the 1st param as a
>>>> > format argument. So for example, request_module("i2c-powermac") should
>>>> > be called as request_module("%s", "i2c-powermac"). Otherwise, new gcc
>>>> > like gcc 4.3.2 on Ubuntu 8.10 would spit out a lot of warnings. This
>>>> > patch fixes them all in linus-git tree.
>>>>
>>>> ... and it doesn't address the underlying problems at all.  A string literal
>>>> without a single % in it is a perfectly sane and valid format.  _Why_ are
>>>> we getting these warning?
>>>
>>> extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
>>>
>>
>>Sorry that after the mail of Viro, I checked again by recover a code
>>and recompile, but got no warning. But actually that code should not
>>be compiled at all.
>>
>>So I checked again by fixing the code that should be compiled
>>(sound/core/sound.c), and can confirm that without the patch we got
>>warning like below:
>>
>>sound/core/sound.c: In function 'snd_request_other':
>>sound/core/sound.c:91: warning: format not a string literal and no
>>format arguments
>
> Hi,all
> I also use Ubuntu 8.10, gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11)
>
> When I compile the latest kernel, there are more warning. Like this:
>
> scripts/genksyms/lex.c: In function 'yylex1':
> scripts/genksyms/lex.l:97: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
> scripts/mod/modpost.c: In function 'get_markers':
> scripts/mod/modpost.c:1542: warning: ignoring return value of 'asprintf', declared with attribute warn_unused_result
> scripts/mod/modpost.c: In function 'add_marker':
> scripts/mod/modpost.c:1962: warning: ignoring return value of 'asprintf', declared with attribute warn_unused_result
> scripts/kallsyms.c: In function 'read_symbol':
> scripts/kallsyms.c:74: warning: ignoring return value of 'fgets', declared with attribute warn_unused_result
> init/main.c: In function 'start_kernel':
> init/main.c:571: warning: format not a string literal and no format arguments
> init/initramfs.c: In function 'populate_rootfs':
> init/initramfs.c:581: warning: format not a string literal and no format arguments
> usr/gen_init_cpio.c: In function 'cpio_mkfile':
> usr/gen_init_cpio.c:357: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
> arch/x86/kernel/dumpstack_32.c: In function 'print_trace_warning_symbol':
> arch/x86/kernel/dumpstack_32.c:125: warning: format not a string literal and no format arguments
> arch/x86/kernel/dumpstack_32.c: In function 'print_trace_address':
> arch/x86/kernel/dumpstack_32.c:147: warning: format not a string literal and no format arguments
> arch/x86/kernel/e820.c: In function 'early_panic':
> arch/x86/kernel/e820.c:1172: warning: format not a string literal and no format arguments
> arch/x86/kernel/e820.c:1173: warning: format not a string literal and no format arguments
> kernel/power/main.c: In function 'test_suspend':
> kernel/power/main.c:720: warning: format not a string literal and no format arguments
> fs/dquot.c: In function 'find_quota_format':
> fs/dquot.c:170: warning: format not a string literal and no format arguments
> crypto/api.c: In function 'crypto_larval_lookup':
> crypto/api.c:218: warning: format not a string literal and no format arguments
> crypto/algapi.c: In function 'crypto_lookup_template':
> crypto/algapi.c:427: warning: format not a string literal and no format arguments
> ...

I saw the same thing. My patch only fixed part of them.

So please submit your patch to fix the remainig :-)

Q

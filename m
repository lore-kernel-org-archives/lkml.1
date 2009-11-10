Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZKJEzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZKJEzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZKJEzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbZKJEzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:55:20 -0500
Message-ID: <4AF8F239.4030407@redhat.com>
Date: Mon, 09 Nov 2009 23:55:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 29 (x86 posttest)
References: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>	<20091029090627.7857ed08.rdunlap@xenotime.net>	<4AE9C74C.2040309@redhat.com>	<20091106085954.39eb2789.rdunlap@xenotime.net>	<4AF8B66B.3010405@redhat.com> <20091110130841.81d76a4b.sfr@canb.auug.org.au>
In-Reply-To: <20091110130841.81d76a4b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> On Mon, 09 Nov 2009 19:40:11 -0500 Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>>
>> Randy Dunlap wrote:
>>> On Thu, 29 Oct 2009 12:48:12 -0400 Masami Hiramatsu wrote:
>>>
>>>> Randy Dunlap wrote:
>>>>>
>>>>> I'm getting this on x86_64:
>>>>>
>>>>>      TEST    posttest
>>>>> Error: ffffffff810299e2:	f2 41 0f 28 52 b0    	repnz movaps -0x50(%r10),%xmm2
>>>>> Error: objdump says 6 bytes, but insn_get_length() says 4 (attr:0)
>>>>> make[2]: *** [posttest] Error 2
>>>>
>>>> Ah, that's should be fixed by AVX support patch which I've posted.
>>>> http://git.kernel.org/tip/e0e492e99b372c6990a5daca9e4683c341f1330e
>>>
>>> Has that been merged into linux-next?
>>> I'm still seeing this failure in linux-next-20091106.
>>
>> I checked it has been merged.
>> So, it should disappear from linux-next-20091109. :-)
> 
> That commit (e0e492e99b372c6990a5daca9e4683c341f1330e "x86: AVX
> instruction set decoder support") has been in linux-next since
> next-20091104, so if Randy's problem still existed in next-20091106, then
> it may be a different problem.

Hmm, this seems a bad sequence, movaps can't have repnz prefix,
since movaps is not string operation... It might happen since
AVX opcodes supporting processors are not released yet.

Anyway, I think we'd better change the posttest to report it
as warning instead of errors.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


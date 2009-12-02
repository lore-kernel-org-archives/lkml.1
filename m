Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZLBAaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZLBAaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZLBAaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:30:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZLBA37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:29:59 -0500
Message-ID: <4B15B4ED.8010209@redhat.com>
Date: Tue, 01 Dec 2009 19:29:33 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu,
       roland@redhat.com, vapier@gentoo.org,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH v2] mm: Introduce coredump parameter structure
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org>	<20091126174835.5A73.A69D9226@jp.fujitsu.com>	<4B0EA3AA.5070003@redhat.com>	<20091126165108.GA13231@redhat.com>	<4B11FB6F.4040403@redhat.com> <20091201161800.fa6b6ae4.akpm@linux-foundation.org>
In-Reply-To: <20091201161800.fa6b6ae4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 28 Nov 2009 23:41:19 -0500
> Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>
>> Introduce coredump parameter data structure (struct coredump_params)
>> for simplifying binfmt->core_dump() arguments.
>>
>> Changes in v2:
>>     - Don't remove DUMP_WRITE() macro.
>
> What is the reason for this change?
>
> Please always include both the "what" and the "why" in changelog text.

I see.

>
>> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
>> index b639dcf..346b694 100644
>> --- a/fs/binfmt_aout.c
>> +++ b/fs/binfmt_aout.c
>> @@ -32,7 +32,7 @@
>>
>>      static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
>>      static int load_aout_library(struct file*);
>> -static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
>> +static int aout_core_dump(struct coredump_params *cprm);
>>
>>      static struct linux_binfmt aout_format = {
>>      	.module		= THIS_MODULE,
>> @@ -89,8 +89,9 @@ if (file->f_op->llseek) { \
>>       * dumping of the process results in another error..
>>       */
>>
>> -static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
>> +static int aout_core_dump(struct coredump_params *cprm)
>>      {
>
> Something horrid has mangled your patch.

Oops, sorry. maybe copy-and-paste buffer demon did it :-(

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


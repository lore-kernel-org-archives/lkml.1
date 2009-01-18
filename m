Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZARFFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZARFFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZARFFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:05:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:9609 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZARFFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HWJOz84nl0TVSm3ErT30+82en+nkvQ9G8WG1ZDCkPs6LFDXqoYWYPrlW3A/DR3ER58
         6jNVS6fm4e+vcaF9x4+7wh/x0MaDMqcJUgf8A2Z9paF5wLTZ4LvSQHI/17h9Z7mMEIUO
         u5yZOe+pcj9b1tUqvdR2qQDmq71iSUXHnsY8I=
MIME-Version: 1.0
In-Reply-To: <4972B6D9.4080101@kernel.org>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
	 <4972B6D9.4080101@kernel.org>
Date: Sun, 18 Jan 2009 00:05:34 -0500
Message-ID: <73c1f2160901172105p8ba1aa4v708e746d5548a79d@mail.gmail.com>
Subject: Re: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 11:58 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Brian Gerst wrote:
>> @@ -211,15 +211,13 @@ ENTRY(secondary_startup_64)
>>        * data area.  Computing this requires two symbols - __per_cpu_load
>>        * and per_cpu__gdt_page.  As linker can't do no such relocation, do
>>        * it by hand.  As early_gdt_descr is manipulated by C code for
>> -      * secondary CPUs, this should be done only once for the boot CPU
>> -      * when early_gdt_descr_base contains zero.
>> +      * secondary CPUs, this should be done only once for the boot CPU.
>>        */
>
> It would probably be nice to mention that it's calculating per cpu
> load addresses for early access.  The comment only refers to gdt_page
> which is a bit misleading as it now also adjusts irqstackptr.
>
> Also, as pda field name, irqstackptr might be fine but wouldn't it be
> better to rename it to at least irq_stack_ptr as this change requires
> touching every users anyway?

I kept the same name unless it would conflict with something.  If you
want to rename it, it should be a separate patch.

--
Brian Gerst

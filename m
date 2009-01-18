Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbZARF5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbZARF5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZARF5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:57:42 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:17184 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZARF5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:57:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXW5qBF6/Ay4KwVuD5NNWGZD1mDePdN92MI3X28CMTRDNR+CIM3WWZWlozq6SfKpGK
         sHZ8dtMrzAZgglmHnvCT1TLe5pLeSFB0F3CWz7XpA1edCSd1/l4XbG3TgdO8nIDCzk70
         Qhg4hq6XvMvfqpIZZ94lH+2Lm+vxCRq+fORY0=
MIME-Version: 1.0
In-Reply-To: <4972B8AB.8040001@kernel.org>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
	 <4972B8AB.8040001@kernel.org>
Date: Sun, 18 Jan 2009 00:57:41 -0500
Message-ID: <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
Subject: Re: [PATCH 05/17] x86-64: Move cpu number from PDA to per-cpu and 
	consolidate with 32-bit.
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 12:05 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
>> --- a/arch/x86/kernel/setup_percpu.c
>> +++ b/arch/x86/kernel/setup_percpu.c
>> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
>>  #endif
>>  EXPORT_SYMBOL(__per_cpu_offset);
>>
>> +DEFINE_PER_CPU(int, cpu_number);
>> +EXPORT_PER_CPU_SYMBOL(cpu_number);
>
> This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
> be unhappy with this change.

Is there any specific reason Voyager doesn't use the x86
setup_per_cpu_areas() function?  I don't see anything on a quick
glance that would not work.  The x86 code is pretty much a superset of
the default code in init/main.c.

--
Brian Gerst

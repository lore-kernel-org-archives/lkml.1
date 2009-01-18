Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbZARGvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbZARGvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 01:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZARGvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 01:51:11 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:51097 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZARGvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 01:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SdBFnFo57lRTE8cOPLP35vLAKPh1uMN7tU46rrtph3kokQtwz6lOOGsBIPCrPU4+wM
         d/hB+iP7AqFEpsT3SnWgKW6muOeTsEwGFy+cgt98AGyBTbi9/tA10eC32qCKK6BgblEm
         iXdT5BY1OxvBov6r3C/qUju3FNIKU2u1QDJcc=
MIME-Version: 1.0
In-Reply-To: <4972C53C.5050509@kernel.org>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
	 <4972B8AB.8040001@kernel.org>
	 <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
	 <4972C53C.5050509@kernel.org>
Date: Sun, 18 Jan 2009 01:51:08 -0500
Message-ID: <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com>
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

On Sun, Jan 18, 2009 at 12:59 AM, Tejun Heo <tj@kernel.org> wrote:
> Brian Gerst wrote:
>> On Sun, Jan 18, 2009 at 12:05 AM, Tejun Heo <tj@kernel.org> wrote:
>>> Hello,
>>>
>>>> --- a/arch/x86/kernel/setup_percpu.c
>>>> +++ b/arch/x86/kernel/setup_percpu.c
>>>> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
>>>>  #endif
>>>>  EXPORT_SYMBOL(__per_cpu_offset);
>>>>
>>>> +DEFINE_PER_CPU(int, cpu_number);
>>>> +EXPORT_PER_CPU_SYMBOL(cpu_number);
>>> This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
>>> be unhappy with this change.
>>
>> Is there any specific reason Voyager doesn't use the x86
>> setup_per_cpu_areas() function?  I don't see anything on a quick
>> glance that would not work.  The x86 code is pretty much a superset of
>> the default code in init/main.c.
>
> I have no idea at all.  Given that not many people can test it, I
> figured just leaving it alone would be the best course but if it can
> be merged, all the better.

Unfortunately Voyager doesn't compile currently for unrelated reasons.
 I'll take a look at incorporating it into these patches, but I can't
even do a compile test right now.

--
Brian Gerst

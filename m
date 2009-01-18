Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZARFU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZARFU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZARFUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:20:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:14837 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZARFUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ocwXVIaVjIuyrNPlyvrdcOJoPIEvZ6+QXQi6D1rF7/TcWw4kQgFizR7x15TXDphTC9
         m0rXpM3l/NZ70F/rAN6oN5B3LRu3a5X0yv/BlbSE8G842Adco4qjNfiPmq8mr3Tn6+x0
         bE5IxAX3jJ5R2fwbxPlTY+GppYOH2bmkqJxqI=
MIME-Version: 1.0
In-Reply-To: <4972B0E3.8060200@kernel.org>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-11-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-12-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-13-git-send-email-brgerst@gmail.com>
	 <4972B0E3.8060200@kernel.org>
Date: Sun, 18 Jan 2009 00:20:45 -0500
Message-ID: <73c1f2160901172120i174a8933qfdb51e654f13c785@mail.gmail.com>
Subject: Re: [PATCH 13/17] x86-64: Remove pda_init()
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 11:32 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Brian Gerst wrote:
>> -void __cpuinit pda_init(int cpu)
>> -{
>> -     struct x8664_pda *pda = cpu_pda(cpu);
>> -
>> -     /* Setup up data that may be needed in __get_free_pages early */
>> -     loadsegment(fs, 0);
>> -     loadsegment(gs, 0);
>> -
>> -     load_pda_offset(cpu);
>> -}
>
> Simply removing these should work fine as they're also initialized in
> other places earlier but I think they still need to be in cpu_init()
> because...
>
> /*
>  * cpu_init() initializes state that is per-CPU. Some data is already
>  * initialized (naturally) in the bootstrap process, such as the GDT
>  * and IDT. We reload them nevertheless, this function acts as a
>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  * 'CPU state barrier', nothing should get across.
>  * A lot of state is already set up in PDA init for 64 bit
>  */

That comment seems like overkill.  It may have been relevant in an
earlier time, but I don't think we need to be so strict now,
especially for things we know are set properly in head_xx.S.

--
Brian Gerst

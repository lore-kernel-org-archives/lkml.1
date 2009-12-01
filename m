Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZLAJTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZLAJTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZLAJT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:19:29 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:59799 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbZLAJT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:19:28 -0500
Message-ID: <4B14DF79.8010908@collabora.co.uk>
Date: Tue, 01 Dec 2009 09:18:49 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient 
 drivers
References: <1259177252.2858.17.camel@calx>	 <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>	 <1259197403.2858.88.camel@calx> <200911282035.26847.rusty@rustcorp.com.au>	 <4B139E3D.1020905@collabora.co.uk> <1259606656.29740.48.camel@calx>
In-Reply-To: <1259606656.29740.48.camel@calx>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2009-11-30 at 10:28 +0000, Ian Molton wrote:
>> Rusty Russell wrote:
>>
>>> And might as well just #defube RNG_BUFFSIZE SMP_CACHE_BYTES (or use
>>> SMP_CACHE_BYTES here and sizeof() elsewhere).
>> This can lead to a rather small (4 byte) buffer on some systems, however
>> I don't know if in practice a tiny buffer or a big one would be better
>> for performance on those machines. I guess if its a problem someone can
>> patch the code to allocate a minimum of (say) 16 bytes in future...
> 
> Hmmm, I think this was bad advice from Rusty.

Not entirely...

> The goal is to size and align the buffer so that we know it will always
> work. Thus 64 bytes (always big enough but not so big that anyone will
> complain) and cache aligned (makes stupid things like Via Padlock happy
> -on Vias-). 

yep. Although making it the size of a cacheline makes sense on /most/
modern architectures - 32 bytes is a very common size - I think the
(current) worst case is one of the drivers wants to dump 3 u64s in one
go. virtio-rng will take what it can...

> Rusty's suggestion could easily have us in trouble if some driver wants
> to hand us a mere 64 bits on an architecture with 4-byte cache alignment
> but is otherwise perfectly happy with 64-bit stores. 

How about SNP_CACHE_BYTES or if less, then 32 bytes minimum? Or just
stick with 64 bytes. Either way works for me.

-Ian

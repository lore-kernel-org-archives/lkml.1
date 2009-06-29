Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbZF2N6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbZF2N6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZF2N6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:58:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:49071 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZF2N6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fG0hjau72ERTWByH6Dee3ctfEVyKtjAyltnG7RERqEl9XgWifbjjGmcRVMpKs2er1D
         B3Aq72feiXCInRG4FGoo4Hm2Bjac3tL/PCWZb9vQ6tzNZ3Yl0SYa5yseFWzfczi4Pt5r
         lZzAqJ0sH24FYq22qrzpaPiNdPnSPIQ/EtZlk=
MIME-Version: 1.0
In-Reply-To: <20090629123142.GL5139@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	 <200906281534.37148.arnd@arndb.de> <20090629123142.GL5139@amd.com>
Date: Mon, 29 Jun 2009 21:51:34 +0800
Message-ID: <d82e647a0906290651yc25e38dkce7d59df5dd86d1f@mail.gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in 
	dma_sync_*_for_cpu
From: Ming Lei <tom.leiming@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/29 Joerg Roedel <joerg.roedel@amd.com>:
> On Sun, Jun 28, 2009 at 03:34:35PM +0000, Arnd Bergmann wrote:
>> On Sunday 28 June 2009 14:39:19 tom.leiming@gmail.com wrote:
>> > From: Ming Lei <tom.leiming@gmail.com>
>> >
>> > dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
>> > dma transfer is over, it seems there is nothing to do with cpu write buffer,
>> > so remove it.
>> >
>> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>>
>> Right, this looks correct. On a related note, flush_write_buffers is
>> architecture specific right now: only x86 and frv implement it at all,
>> though and with slightly different semantics.
>
> This doen't look correct to me. The sync functions may do bounce buffering
> which is all about copying data from one place in main memory to another. So we
> need these flush_write_buffer() calls in the _for_cpu path too.

IMHO, even we do not call flush_write_buffer(), CPU can read correct
data from the
dma buffer since write buffer can't affect cache, right?

Thanks.

>
>> Maybe it would be more consistent to change the dma_map_* and
>> dma_sync_*_for_device stuff there to wmb() to make it  portable
>> to other architectures.
>
> If we change it to wmb() it would be executed every time there even if the
> processor doesn't require it. Other architectures could simply add a
> flush_write_buffers() implemention if they want to adapt the common dma-mapping
> implementation, no?
>
>        Joerg
>
> --
>           | Advanced Micro Devices GmbH
>  Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
>  System    |
>  Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
>  Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>           | Registergericht München, HRB Nr. 43632
>
>



-- 
Lei Ming

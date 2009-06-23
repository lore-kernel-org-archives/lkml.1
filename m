Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZFWC3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZFWC3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZFWC3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:29:47 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:59671 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZFWC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fDianlKf4+8w616F8SzUJNlby15bCyoqfIOBqjvTjYecA2d2HiqfPGn3yGY5qCvf/f
         WJfypih8CClvDF2EAlwEKIkirOMjZByYdDWiARWxwohuMEvzQvn4td/ZVBqdkWHBOcOf
         dEeg60OkG3FwCq8pJ0q4zMbW5C+9H+64e5ktM=
MIME-Version: 1.0
In-Reply-To: <20090623111430D.fujita.tomonori@lab.ntt.co.jp>
References: <1245722086-13340-1-git-send-email-vapier@gentoo.org> 
	<1245722086-13340-2-git-send-email-vapier@gentoo.org> <20090623111430D.fujita.tomonori@lab.ntt.co.jp>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 22 Jun 2009 22:29:29 -0400
Message-ID: <8bd0f97a0906221929y51af5000w63e2edb7e54abe74@mail.gmail.com>
Subject: Re: [PATCH 2/2] Blackfin: fix dma-mapping build errors
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 22:14, FUJITA Tomonori wrote:
> On Mon, 22 Jun 2009 21:54:46 -0400 Mike Frysinger wrote:
>> The recent deprecation of dma_sync_{sg,single} ironically broke Blackfin
>> systems.
>
> Oops, sorry about that.
>
>> This is because we don't define dma_sync_sg_for_cpu at all, so
>> until the DMA asm-generic conversion/cleanup is done after the next
>> release, simply redirect the dma_sync_sg_for_cpu to the debug version.
>
> This doesn't look correct (though it works). dma-debug.h is supposed
> to be used by architectures that support DMA_API_DEBUG feature
> (blackfin doesn't support it). dma_sync_sg_for_cpu is not the
> debug version of dma_sync_sg_for_cpu.

guessing you meant "debug_dma_sync_sg_for_cpu is not the debug version
of dma_sync_sg_for_cpu"

> I think that simply adding dummy dma_sync_single_for_device() is a
> proper solution (as blackfin already does wrt dma_sync_single_for_cpu
> and dma_sync_single_for_device).
>
> Architectures are also supposed to have dma_sync_sg_for_cpu and
> dma_sync_sg_for_device, so let's add both.

i'm not really familiar with the DMA mapping functions, so if you say
this is the way to go, then it's fine by me.  not like it'll lead to
any runtime failures for us.
-mike

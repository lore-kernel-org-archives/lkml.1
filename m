Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZF2OzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZF2OzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZF2Oyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:54:50 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:45116 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbZF2Oyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:54:49 -0400
X-Greylist: delayed 3797 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 10:54:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rb8fMHvn+EUtDJkWZaPLThXzqgsPSE2ZO/gmBdvg2LnEsthCCrrVkVYuUIxSQTPekL
         Ido5CVg0MYDUnaUsze5JdThbjbaP2xv1kVNjKhTX5MF4R0D+nxSnwYAmjzXuoeKlIulR
         X6AW7zWXM/YjUrF06CeQCMNzOAXUnBjE6HSMM=
MIME-Version: 1.0
In-Reply-To: <20090629144536.GP5139@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	 <200906281534.37148.arnd@arndb.de> <20090629123142.GL5139@amd.com>
	 <d82e647a0906290651yc25e38dkce7d59df5dd86d1f@mail.gmail.com>
	 <20090629144536.GP5139@amd.com>
Date: Mon, 29 Jun 2009 22:54:51 +0800
Message-ID: <d82e647a0906290754t13bc1b37s6ea6fd582a7fdbe@mail.gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in 
	dma_sync_*_for_cpu
From: Ming Lei <tom.leiming@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/29 Joerg Roedel <joerg.roedel@amd.com>:
>>
>> IMHO, even we do not call flush_write_buffer(), CPU can read correct
>> data from the
>> dma buffer since write buffer can't affect cache, right?
>
> flush_write_buffer is not about cache flushing. It is about read/write
> reordering in the CPU. Think of it as a memory barrier. On most x86

You mean we may need a memory barrier between writing data from bouncing buffer
to dma buffer and reading data from dma buffer, do you?

> systems this function is therefore a nop. Cache flushing for
> architectures without cache-coherent DMA is typically handled in their
> low-level dma-api code (I have seen that at least in parisc32).



-- 
Lei Ming

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbZCQBNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbZCQBNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZCQBNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:13:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:38137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZCQBNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mHOaivsuxe2V/2JiMbspp5EFt4J12bm+3UVpLcp6UL9D9QvLfYSNqoSc2bHF2zN2Fh
         DSefuaZN8uL0XIlOssVMmA2yTUUiY5FeZAX000qswSAnMtXgMqvRpSPix/GMoQS/FMUO
         nxQihuKEGPW2pcdDlq4zsjLZTEfArfC7e8aNk=
MIME-Version: 1.0
In-Reply-To: <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
References: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
	 <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 16 Mar 2009 18:13:34 -0700
Message-ID: <43e72e890903161813q1e069891jb7c669a539e3ff7f@mail.gmail.com>
Subject: Re: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-wireless@vger.kernel.org, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 5:35 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 16 Mar 2009 12:15:37 -0700
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>
>> I've run into "PCI-DMA: Out of IOMMU space" messages after loading and
>> unloading a module 30 times. The interesting thing is this only
>> happens if I have > 4 GB of memory. The box this occurs has AMD Phenom
>> quad core CPU so I take it a harware IOMMU is being used. Below are
>> example relevant messages with > 4 GB and then < 4 GB of memory. The
>> driver I tested this with was ath9k. It could be an issue perhaps with
>> ath9k but I am unable to find an issue in our probe/removal.
>>
>> Could this be an issue with the AMD IOMMU used? Or is it more likely a
>> driver issue?
>
> ath9k wants DMA_32BIT_MASK, right? If so, GART IOMMU does nothing on a
> system with < 4GB memory since ath9k can access to all the memory
> addresses directly. With >4GB memory, GART needs to remap an address
> higher than 4GB because ath9k wants DMA_32BIT_MASK.
>
> From a quick look, ath9k doesn't call pci_unmap_single for rx
> buffers. Though I might be wrong because I don't know anything about
> the driver.

You seem to be right actually, we were calling pci_unmap_single() for
rx buffers on the RX tasklet but never for the simple case of removing
the module. Will test it out in a bit.

 Luis

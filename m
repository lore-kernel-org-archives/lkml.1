Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZLUTsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZLUTsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZLUTsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:48:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47812 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZLUTsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hj0GAr6uwG53RRxu7ZUCPlMg7/wsnDqQsoZ6CcEFKVDrcEvtEfJwVnSSv9b9K9nWgg
         CSxPyyX6MKOHg6P5xa/frp8YgE6pyRhv9/t4TE5C7JZMCrfHWSyHuURDt4IPqssUo5cw
         P2yCBnlfnq/DNw+Cm3PcoM07rFVlzDooyOfdU=
Subject: Re: Does pci_map_single magicly work on > 32 bit address for 32bit
  capable device?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <51f3faa70912111638h5940612em5e6a14c166e108b1@mail.gmail.com>
References: <1260567582.5983.23.camel@maxim-laptop>
	 <4B22DEA7.8040202@gmail.com> <1260577137.8536.20.camel@maxim-laptop>
	 <51f3faa70912111638h5940612em5e6a14c166e108b1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 21:48:35 +0200
Message-ID: <1261424915.4328.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 18:38 -0600, Robert Hancock wrote: 
> On Fri, Dec 11, 2009 at 6:18 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> The kernel should set up an IOMMU (either hardware or software) mapping
> >> for that memory so that the device can access it through an address
> >> below 4GB. This is assuming it's a 64-bit kernel (on 32-bit, a kernel
> >> memory address will always be below 4GB).
> >
> > What do you mean by software IOMMU?
> >
> > On my system there is no IOMMU present, so only way to ensure 32 bit
> > address is to copy pages.
> > pci_map_single could copy the data for write case, and pci_unmap_single
> > for read case, but I now strongly doubt they do.
> 
> It does. See the swiotlb code. You should see some message on bootup like:
> 
> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
> software IO TLB at phys 0x20000000 - 0x24000000

Finally got my hands on this.
I thought that swiotlb is a hardware feature and its only supported on
AMD cpus.
I think I have seen that in Kconfig


swiotlb is not used on my system, but that is just due to the fact my
system has 64 bit kernel and 2 GB of memory.

Since swiotlb is generic, this I guess means that any physical address
and aligned address can be thrown at dma api, and it will still work.
Very nice.

Although, the fact that swiotlb memory space is constant, is a bit of a
problem, because this introduces a point of failure.

For me it doesn't matter at all, because all I need is 512 bytes.


Best regards,
Maxim Levitsky



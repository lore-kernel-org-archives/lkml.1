Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZLLAiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZLLAiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZLLAiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:38:05 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:64082 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZLLAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:38:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f6hxvcJVN8OYccDdO5K2Q0EKn1n32chCyS0we411Wjhwmx15qinEwwQVzs2ssEssWa
         647fCDUHimlhpB7Pw5LLW7/Gvs7i42l0zIlxaHE/6rqCSmjZLxlpI3Xd9l7VPd22arij
         FpEVkb1KZPMGhLKVoWYijwx2wV93Y7c0TRW5I=
MIME-Version: 1.0
In-Reply-To: <1260577137.8536.20.camel@maxim-laptop>
References: <1260567582.5983.23.camel@maxim-laptop>
	 <4B22DEA7.8040202@gmail.com> <1260577137.8536.20.camel@maxim-laptop>
Date: Fri, 11 Dec 2009 18:38:09 -0600
Message-ID: <51f3faa70912111638h5940612em5e6a14c166e108b1@mail.gmail.com>
Subject: Re: Does pci_map_single magicly work on > 32 bit address for 32bit 
	capable device?
From: Robert Hancock <hancockrwd@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 6:18 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> The kernel should set up an IOMMU (either hardware or software) mapping
>> for that memory so that the device can access it through an address
>> below 4GB. This is assuming it's a 64-bit kernel (on 32-bit, a kernel
>> memory address will always be below 4GB).
>
> What do you mean by software IOMMU?
>
> On my system there is no IOMMU present, so only way to ensure 32 bit
> address is to copy pages.
> pci_map_single could copy the data for write case, and pci_unmap_single
> for read case, but I now strongly doubt they do.

It does. See the swiotlb code. You should see some message on bootup like:

PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000

> I am not sure at all that these functions will fail if too high address
> is specified....
>
> Also, very recently, I found that in
> Documentation/DMA-API.txt, there is a statement that says that
> pci_map_single fails for >32 bit memory address.

Where do you see this?

>
> I guess I just do a memcpy...

This isn't optimal because if there is a hardware IOMMU, the copy can
be avoided.

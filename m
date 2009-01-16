Return-Path: <linux-kernel-owner+w=401wt.eu-S937438AbZAPTWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937438AbZAPTWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936756AbZAPTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:21:51 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56670 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZAPTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HoyDp8urqh9wwdnKYARsKkM6xgfeaz9UjTm7lPWBkb4iBJQbmz6+iatb0svD5deCjz
         Lpm9wZ4mdXk1UvpbasyfneXPRWfJ2hvKMdXEoXndR9f3sCKsADY6OmAsZsh02rPnhLA1
         +TSt0uvKdDasYowD2AF118dNTQ5I6ISJ7nXsA=
Message-ID: <19f34abd0901161121j2f5a21b5g2a73036dc20766ad@mail.gmail.com>
Date: Fri, 16 Jan 2009 20:21:47 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: fix no_pci_devices() #2
Cc: "Greg KH" <gregkh@suse.de>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200901161041.10071.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081220111419.GA5367@localhost.localdomain>
	 <200901051109.43953.jbarnes@virtuousgeek.org>
	 <20090107004258.GA3223@suse.de>
	 <200901161041.10071.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 7:41 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> > Assuming Greg already took the generic part, can you resend the PCI part
>> > to the linux-pci@vger.kernel.org list for review just in case anyone has
>> > a better idea of how to do it?
>>
>> Did I take the generic part?  I can't remember...
>
> Doesn't look like it.  Vergard can you send out an updated patch set?

Actually, my patch is still just a hack, since pci_bus_type.p is still
set before the pci_bus_type is really usable. So if the kernel crashes
(or, in general, no_pci_devices() is called) at some point between the
pci_bus_type.p = <something> and pci_bus_type.p = NULL (which I
inserted), we will still see the same type of fault.

So I would prefer to solve this in a different way, like a dedicated
flag which is only set after we know that pci_bus_type initialisation
succeeded. I think that was the approach of my first patch? I don't
remember. In any case, such a patch could not be split in generic/pci
parts, I think. Also, should we anticipate concurrent access to
pci_bus_type.p or such a dedicated "no_pci_devices" flag?

Here is the first patch, but I wonder if it should be turned into
atomic_t instead: http://lkml.org/lkml/2008/12/20/33


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

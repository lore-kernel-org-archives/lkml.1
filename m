Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYH2Vkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYH2Vkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYH2Vka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:40:30 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:50890 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYH2Vk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:40:29 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 17:40:29 EDT
From: Jari Aalto <jari.aalto@cante.net>
To: linux-kernel@vger.kernel.org
Cc: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
References: <48B843CC.1050805@yahoo.com.ar>
Date: Sat, 30 Aug 2008 00:31:51 +0300
In-Reply-To: <48B843CC.1050805@yahoo.com.ar> (Gerardo Exequiel Pozzi's message
	of "Fri, 29 Aug 2008 15:45:32 -0300")
Message-ID: <87wshza4oo.fsf@jondo.cante.net>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar> writes:

>>    REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread >start)
>>
>>but I'll try that once more with this 2.6.26 kernel to double check.
>
> You have mixed options for "swiotlb" and "amd gart", see the
> Documentation/x86_64/boot-options.txt

It's difficult to find the pointer that could explain the correct use of
the options and their combinations.

> iommu=soft,memaper=3 swiotlb=65536 BAD.
>
> memaper=3 don't have any effects here, memaper is only for "AMD GART"
>
> The noagp option in this motherboard is redundant.
>
> iommu=noagp,noaperture,off swiotlb=512M BAD combination options!
> OFF, OFF, OFF, ON: The result are unknown.
>
> You need to use the IOMMU (from AMD GART) that with your options: you
> never used.
>
> When you boot with no iommu options, kernels uses the AMD GART in this
> system, with an aperture of 64MB (too small) to fix, you need only one
> option: iommu=memaper=3

This sort of advice wouldbe wonderful if it wereincluded in the spec,
which as of now is too technical for mere mortals:

    http://www.mjmwired.net/kernel/Documentation/x86_64/boot-options.txt

I'm not surprised that end user cannot know what combination of options
make or does not make sense. I'll try at next boot with plain:

    iommu=memaper=3

Thank you,
Jari

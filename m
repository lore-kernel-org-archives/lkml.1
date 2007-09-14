Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXINQ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXINQ5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXINQ4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:56:53 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:19437 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbXINQ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dwVGx1GG/4MGNaQosudDz5tVteOZ4l7+NdjBIE/1VAcQ2EeyoIU+HaaPeZr/H0FK6PfSugTFIIBJk1eU0u0V/V2fY8/Q/x9frHIss3jCtycRoycfsgDu51TNsxJf1AHr9vZl2KuIuNxOYCuNDzFiZLSvZPHgDCV3HSLYfUBlTeM=
Message-ID: <46EABD48.3020902@gmail.com>
Date: Fri, 14 Sep 2007 20:56:40 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Markus Rechberger <mrechberger@gmail.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com> <46EA3F07.9050806@gmail.com> <20070914091535.GA8998@8bytes.org> <46EA77DE.8060109@gmail.com> <20070914161345.GB8998@8bytes.org>
In-Reply-To: <20070914161345.GB8998@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:

>>> Common new IOMMUs have only very few in common with the AGP GART. In
>>> fact, with current modern IOMMU hardware it will be possible to
>>> implement secure userspace device drivers that are even able to do DMA.
>>> This is not possible with the GART.
>>>
>>>> Though you get a physical to virtual translation, what about interrupts,
>>> Modern IOMMUs are able to remap interrupts. This will solve the problem
>>> with PCI interrupt sharing.
>> What CPU's are we talking about ?
> 
> IOMMUs are not necessarily a CPU feature. These IOMMUS will be found in
> the South/North Bridge or even on PCI devices itself (uncommon). The
> Calgary IOMMU is such an example of an IOMMU not implemented on the CPU
> itself.
> 


I do understand that (an earlier reply from Grant Grundler on the same
[1], while working on something else), but that wasn't exactly what i
was getting at. The bridges are in fact tied up with a certain CPU class.

Though your argument holds true: "secure userpsace device drivers can be
implemented with modern hardware" There is a large flaw in it. (From an
academic POV, you are correct)

Now, if all the drivers were to depend on that certain feature, what
happens to all other CPU class users ? Looking at a pile of CPU's being
used, also not to forget that devices such as STB's use even very small
embedded CPU's such as the PPC405 Vulcan based [2] to mobile devices
such as mobile phones using ARM, Xtensa [3], OMAP CPU's/platforms, which
do not in any way use the bridges nor the CPU class which you however
mention.

So .. we are looking at a small segment, ie. a subset of the PC users
even, even if the larger segments like STB's can be ignored. This would
mean that only a small subset of users using a certain CPU class can use
those drivers (eventhough the devices themselves don't have that
limitation, the limitation being the implementation of the driver
alone), which is absurd.


Manu

[1] http://lkml.org/lkml/2007/5/26/217
[2] http://abraham.manu.googlepages.com/p3160033.jpg
[3] http://tensilica.com/

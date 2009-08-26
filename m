Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZHZGQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZHZGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZHZGQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:16:27 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:38482 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbZHZGQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:16:26 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 02:16:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XbeEZK+TQQqFNqu9VMuFNb/yORnYwPcgWeYDqIs0WM13VPBqkwYDzdf//lMXXFD5Ns
         jjSJ/69gGlwML8bXwL+0uohECo7M7uOMTgMsRt22k4GoVChdpGrT6Uizq02Hergejn6V
         cMSMp+Py+Va7nKL7hxEFD5LosknwQH6vqPhfk=
MIME-Version: 1.0
In-Reply-To: <4A93E192.9000109@inria.fr>
References: <4A93E192.9000109@inria.fr>
Date: Tue, 25 Aug 2009 23:10:09 -0700
X-Google-Sender-Auth: 7b607069f2fa853d
Message-ID: <e9c3a7c20908252310n72bc3375nf79912bac40c0d92@mail.gmail.com>
Subject: Re: how to get a DMA channel near a process?
From: Dan Williams <dan.j.williams@intel.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 6:05 AM, Brice Goglin<Brice.Goglin@inria.fr> wrote:
> Hello,
>
> I am playing with DMA engine on a Nehalem box with two X58 chipsets
> (Supermicro X8DAH). My understanding is that there are 8 DMA channels on
> each chipset, so 8 channels near each processor. Unfortunately, my BIOS
> and 2.6.31-rc still wrongly reports the physical location of my devices
> (it claims all PCI devices are near the first processor) but I worked
> around the problem manually.
>
> The offloaded copy performance changes a lot depending on whether the
> process memory is allocated near the DMA device. So first I would like
> to know if DMA channels are allocated near the requesting
> processor/process. Then I guess it's possible to read the cpu mask near
> a given chan by following chan->dev.device up to the pci device, right?
> But is there any way to request a DMA channel near a specific socket or
> NUMA node or cpu mask?

If we can determine the topology of which chipset is closer to which
cpu package then we can modify the dmaengine channel_table to return
"local" channels via dma_find_channel().  The current allocation
policy is blind per-cpu round robin such that cpu-0 gets channel-0,
cpu-1 gets channel-1...  As you pointed out the challenge will be
finding a reliable source for the topology information.

--
Dan

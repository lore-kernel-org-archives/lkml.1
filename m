Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZHZFSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZHZFSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZHZFSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:18:48 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:36457 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZHZFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Dq1RcCRWnj4XgdSDqiXEi/glIwKJMxMmiucNQ/CZ6iHtVCbLMRWKpk6cedmb3W8dk0
         so6CwwxSHQUcNV2hp9zusBYeFiQxQo5F87vSIcVKAva36FIJ/70KCtCYAbrP1ISxRpNQ
         eHRquzNmtrwH0Codsh3/4VVc9zBcI8JnICFpw=
Message-ID: <4A94C5B6.3060907@gmail.com>
Date: Tue, 25 Aug 2009 23:18:46 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to get a DMA channel near a process?
References: <4A93E192.9000109@inria.fr>
In-Reply-To: <4A93E192.9000109@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 07:05 AM, Brice Goglin wrote:
> Hello,
>
> I am playing with DMA engine on a Nehalem box with two X58 chipsets
> (Supermicro X8DAH). My understanding is that there are 8 DMA channels on
> each chipset, so 8 channels near each processor. Unfortunately, my BIOS

Don't think that DMA channel is the term you are looking for, maybe PCI 
Express lanes? DMA channels are an ancient ISA thing.

> and 2.6.31-rc still wrongly reports the physical location of my devices
> (it claims all PCI devices are near the first processor) but I worked
> around the problem manually.

Presumably incorrect information in the BIOS tables (SLIT or MADT, maybe?)

>
> The offloaded copy performance changes a lot depending on whether the
> process memory is allocated near the DMA device. So first I would like
> to know if DMA channels are allocated near the requesting
> processor/process. Then I guess it's possible to read the cpu mask near

Not sure quite what you are trying to say here. Normally when memory is 
allocated for DMA use for a specific device I believe the kernel tries 
to allocate it on the same node that the device is attached to.

> a given chan by following chan->dev.device up to the pci device, right?
> But is there any way to request a DMA channel near a specific socket or
> NUMA node or cpu mask?
>
> Thanks,
> Brice
>
>


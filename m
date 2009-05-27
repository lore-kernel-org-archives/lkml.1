Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZE0AXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZE0AXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZE0AXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:23:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43373 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZE0AXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:23:09 -0400
Message-ID: <4A1C86F5.1020603@jp.fujitsu.com>
Date: Wed, 27 May 2009 09:19:01 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-pci@vger.kernel.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, towerlexa@gmx.de
Subject: Re: Who's responsible for configuring CLS on a cardbus device?
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com> <4A1C8091.4050909@kernel.org>
In-Reply-To: <4A1C8091.4050909@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Robert Hancock wrote:
>> Alan Cox wrote:
>>> Currently its handled by pci_set_mwi() but there isn't actually a more
>>> direct way to do this.
> 
> Thanks Alan.
> 
>> Yeah, I guess the assumption is that unless the device is using MWI it
>> doesn't care about cache line size. However, in the case of the sata_sil
>> controllers (and possibly other devices), the device cares about it for
>> other purposes (I think it's FIFO handling in this case).
>>
>> Maybe we should just be setting the cache line size somewhere more
>> basic, like pci_set_master or something?
> 
> Hmmm... given that it is something which is usually handled by the
> system firmware, wouldn't it be more fitting to configure it from pci
> hotplug code?
> 

I don't know cardbus devices at all, but Standard Hot-Plug Controller
driver ('shpchp') and PCI Express Hot-Plug controller driver ('pciehp')
configures cache line size of hot-added device. The cache line size is
gotten from firmware through ACPI _HPP or _HPX method.

Thanks,
Kenji Kaneshige



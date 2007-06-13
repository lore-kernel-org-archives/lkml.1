Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXFMHkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXFMHkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 03:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXFMHkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 03:40:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:15211 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXFMHkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 03:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=GldfbqHm2ApnYrFPpS6hVT0VQPN3hYB8PX5s4vETTJ0DTAMz3q+c7+J024TnS80Xz+qp1DNDfOhdieQ8Y9yJCL1KQ2JI6LyfRWaKPlmZduDVYGmhyQk712zfa3XOcVpv3m0jW0s+bj5S7Wcnj3U2lq91NMl6t6/Y0UaGH9MKxYs=
Message-ID: <466F9F4D.7060003@gmail.com>
Date: Wed, 13 Jun 2007 11:39:57 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci probe
References: <4648B29A.6080406@gmail.com> <4649B270.8050002@gmail.com> <20070516071851.GB19294@kroah.com> <464AF932.9070008@gmail.com> <20070529222735.GK4644@kroah.com>
In-Reply-To: <20070529222735.GK4644@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for my late reply.

Greg KH wrote:
>>> 	- your driver will not work on any pci-hotplug type system (that
>>> 	  includes expresscard and pccard and lots of high-end servers.
>> This doesn't matter
> 
> Are you sure?  PCI Hotplug is showing up in more places that people
> realize...


The PCI bridges that we have for the mentioned use, does not support
Hotplugging at all and hence doesn't matter for those devices mentioned.


>>> 	- your driver will not be notified if the system is being
>>> 	  suspended or resumed or wanting to drop into a low power
>>> 	  state.
>>> 	- another driver can bind to your device without you ever
>>> 	  knowing it.
>> These also sound bad.
>>
>>> So in short, use pci_probe and just handle the fact that you need to be
>>> called for two PCI devices and bind to both of them.  It shouldn't be
>>> that hard...
>> Thanks for the explanation.
>>
>> Do you mean to have two PCIID tables ? But then that does mean 2 modules
>> don't you ? (i thought probe would be called once per module) Or you
>> mean to say use PCI_ANY_ID in the table to match multiple devices and
>> then allow probe to return a list of devices ?
> 
> 
> No, you can specify multiple devices in the same device id table, and
> your driver will get called for all of the matching devices.  You just
> need to "bind" them together in your driver to be able to handle
> everything properly.  It shouldn't be that tough.
> 

Will take a go at it.
I was using PCI_ANY_ID for the device id, so that should return all the
devices.


Thanks,
Manu

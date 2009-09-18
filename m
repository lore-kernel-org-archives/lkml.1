Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZIRRzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZIRRzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZIRRzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:55:21 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:46251 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbZIRRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:55:20 -0400
Message-ID: <4AB3C988.2040303@codemonkey.ws>
Date: Fri, 18 Sep 2009 12:55:20 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Amit Shah <amit.shah@redhat.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>	<20090911170010.34c80f2d@linux.intel.com>	<20090911163806.GB25535@amit-x200.redhat.com>	<4AAA8838.1080106@codemonkey.ws>	<20090911173307.GB27046@amit-x200.redhat.com>	<4AAA8A56.3040707@codemonkey.ws>	<20090916112332.6bf981a5@linux.intel.com>	<4AB164A0.8000402@codemonkey.ws> <20090918170048.53ba8cf6@linux.intel.com>
In-Reply-To: <20090918170048.53ba8cf6@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> We do actually want hangup and a few other of the tty specific ops.
>> The only thing we really don't want is a baud rate.
>>     
>
> So you need break, parity ... no be serious please
>   

Sure, why not?

In QEMU, we have the ability to hook our devices directly to a physical 
serial device and we pass through break, parity, and the other serial 
device properties.

Again, this is paravirtual serial device and I think it's entirely 
reasonable for people to hook up these ports in the guest directly to 
physical serial devices in the host.

>> This device cannot be implemented as-is in userspace because it
>> depends on DMA which precludes the use of something like uio_pci.  We
>> could modify the device to avoid dma if the feeling was that there
>> was no interest in putting this in the kernel.
>>     
>
> So you need a tiny kernel side driver to unpack it into a meaningful
> fs, or just a user-user channel with a daemon each end and a protocol
> over it - nothing kernel in that.
>   

I think there's some confusion over what this driver actually is.

 From my perspective, this is a paravirtual serial device and nothing 
more.  All the discussion of things like guest copy/paste support is a 
bit silly.  This is the wrong way to approach that sort of thing because 
it's not something that belongs in the kernel at all.  Furthermore, the 
current proposal doesn't handle anything like save/restore which is 
needed for live migration.

> We don't implement tcp/ip http sessions as tty devices with the kernel
> as web server and the same logic applies here.
>   

I fail to see how this is at all relevant.  This is a virtual machine, 
we're presenting virtual hardware that behaves like a serial device.  
Where web servers fit in is completely beyond me.

Regards,

Anthony Liguori

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYGJXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYGJXm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYGJXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:42:48 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:56210 "EHLO
	pd3mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753214AbYGJXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:42:47 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=iecK5QHjX_ZIN2BwQZgA:9 a=GU9LRbqbh1sVlS4SG1ZZUz1a7m0A:4 a=MSl-tDqOz04A:10 a=cbiHbSXtdN4A:10 a=jKsaoXOG-p4A:10
Message-ID: <48769EE4.3050101@shaw.ca>
Date: Thu, 10 Jul 2008 17:44:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: darrell.holigan@gmail.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Providing access to kernel memory from PCI bus
References: <61c5c72f-6427-4dbf-b608-ceedc1859425@m45g2000hsb.googlegroups.com>
In-Reply-To: <61c5c72f-6427-4dbf-b608-ceedc1859425@m45g2000hsb.googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

darrell.holigan@gmail.com wrote:
> I'm developing a PCI driver under linux to communicate with an Intel
> IQ80331 which supports PCI boot.  To accomplish this, the IQ80331
> needs access to an image stored in the host processor's (AMCC 405GPr)
> RAM.
> 
> Linux boots, sees the PCI bridge and the address translation unit on
> the IQ80331 (core is held in reset) and calls the probe function my
> driver which retrieves the address allocated to BAR0 and ioremaps it.
> The IQ80331 implements a single BAR which provides access to ATU
> registers.
> 
> From here, I can configure the IQ80331 through BAR0 to do a long jump
> at boot.  According to the dev manual I need to configure the outbound
> window of the ATU so that it translates the jump to host memory where
> my boot image is stored.
> 
> I have kmalloced kernel memory in my driver's ioctl and loaded in the
> image from user space, but I do not understand the process to tell the
> kernel that I want the kmalloced area available for access from PCI
> devices.  I assume that I must do this explicitly since allowing
> unrestricted access to kernel memory from PCI space would be a
> security/stabilty concern, yes?  But I cannot find the proper kernel
> API calls to do this.

You should likely allocate the memory that you are making available to 
the device using dma_alloc_coherent. That will give you a bus address 
that points to the memory that you can give to your device.

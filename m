Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbXKHTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbXKHTFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761594AbXKHTEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:04:53 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54798 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761547AbXKHTEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:04:52 -0500
Message-ID: <47335DC6.7090603@us.ibm.com>
Date: Thu, 08 Nov 2007 13:04:38 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com> <11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com> <200711081846.36821.arnd@arndb.de>
In-Reply-To: <200711081846.36821.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 08 November 2007, Anthony Liguori wrote:
>   
>> +/* A PCI device has it's own struct device and so does a virtio device so
>> + * we create a place for the virtio devices to show up in sysfs.  I think it
>> + * would make more sense for virtio to not insist on having it's own device. */
>> +static struct device virtio_pci_root = {
>> +       .parent         = NULL,
>> +       .bus_id         = "virtio-pci",
>> +};
>> +
>> +/* Unique numbering for devices under the kvm root */
>> +static unsigned int dev_index;
>> +
>>     
>
> ...
>
>   
>> +/* the PCI probing function */
>> +static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>> +                                     const struct pci_device_id *id)
>> +{
>> +       struct virtio_pci_device *vp_dev;
>> +       int err;
>> +
>> +       /* allocate our structure and fill it out */
>> +       vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
>> +       if (vp_dev == NULL)
>> +               return -ENOMEM;
>> +
>> +       vp_dev->pci_dev = pci_dev;
>> +       vp_dev->vdev.dev.parent = &virtio_pci_root;
>>     
>
> If you use 
>
> 	vp_dev->vdev.dev.parent = &pci_dev->dev;
>
> Then there is no need for the special kvm root device, and the actual
> virtio device shows up in a more logical place, under where it is
> really (virtually) attached.
>   

They already show up underneath of the PCI bus.  The issue is that there 
are two separate 'struct device's for each virtio device.  There's the 
PCI device (that's part of the pci_dev structure) and then there's the 
virtio_device one.  I thought that setting the dev.parent of the 
virtio_device struct device would result in having two separate entries 
under the PCI bus directory which would be pretty confusing :-)

Regards,

Anthony Liguori

> 	Arnd <><
>   


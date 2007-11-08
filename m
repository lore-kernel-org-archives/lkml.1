Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXKHRsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXKHRsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbXKHRsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:48:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887AbXKHRsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:48:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
Date: Thu, 8 Nov 2007 18:46:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <11944899922822-git-send-email-aliguori@us.ibm.com> <11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11944900163817-git-send-email-aliguori@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711081846.36821.arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.osdl.org, Anthony Liguori <aliguori@us.ibm.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+yaos9mut0YJsT5bE9UUBemp/Ae59czln3FGp
 ld0NuK8jgfhn5o7RKBF/eeN7oAHHupiTrxys608iFB/S61CdYw
 aDd3mzkHTnZSU+EaywNvg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007, Anthony Liguori wrote:
> +/* A PCI device has it's own struct device and so does a virtio device so
> + * we create a place for the virtio devices to show up in sysfs.  I think it
> + * would make more sense for virtio to not insist on having it's own device. */
> +static struct device virtio_pci_root = {
> +       .parent         = NULL,
> +       .bus_id         = "virtio-pci",
> +};
> +
> +/* Unique numbering for devices under the kvm root */
> +static unsigned int dev_index;
> +

...

> +/* the PCI probing function */
> +static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
> +                                     const struct pci_device_id *id)
> +{
> +       struct virtio_pci_device *vp_dev;
> +       int err;
> +
> +       /* allocate our structure and fill it out */
> +       vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
> +       if (vp_dev == NULL)
> +               return -ENOMEM;
> +
> +       vp_dev->pci_dev = pci_dev;
> +       vp_dev->vdev.dev.parent = &virtio_pci_root;

If you use 

	vp_dev->vdev.dev.parent = &pci_dev->dev;

Then there is no need for the special kvm root device, and the actual
virtio device shows up in a more logical place, under where it is
really (virtually) attached.

	Arnd <><

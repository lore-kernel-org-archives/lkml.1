Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYJQOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYJQOu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYJQOuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:50:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:58997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbYJQOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OLWiD0+x+uUkyUcX+dbsKps5dTzRdfGdgdeRDdNZ1K60ADp+db1L7kSL75w5Ay0LgF
         YRtz6rLbA4mjb1sBBaVDv723gtCvN5Kd6e4LDsyNEuEbkpcKmVYiRoITudHFe1CG72Kt
         6+LtK0IKgjZ7jg5VbBIxwj7z6sCwB4lQLbMso=
Message-ID: <c49e66200810170750s2d06d035m28ce5da3e6ca9c38@mail.gmail.com>
Date: Fri, 17 Oct 2008 16:50:13 +0200
From: "Pieter Steyn" <pieterste@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: r6080 driver not working.
Cc: tech@dmp.com.tw
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I cannot get the r6080 driver working properly in either 2.6.26 or
2.6.27.  It compiles, and loads fine enough, but as soon as I try and
bring up the device I get a 'resource is in use and busy' message.

I've tried using both the driver supplied by the kernel and the one
linked on their website (with some modifications to make it compile :

r6040# diff r6040.c r6040.orig
277a278
>       SET_MODULE_OWNER(dev);
380c381
<       i = request_irq(dev->irq, &r6040_interrupt, IRQF_SHARED,
dev->name, dev);
---
>       i = request_irq(dev->irq, &r6040_interrupt, SA_SHIRQ, dev->name, dev);
1079c1080
<       return pci_register_driver (&r6040_driver);
---
>       return pci_module_init (&r6040_driver);

Networking works with 2.6.21 using the driver from their website and
the above patch.

I've cc'ed in tech support to the manufacturer.

Thanks, and sorry if the information isn't much to work with...but
since I don't get any errors other than device being busy I'm not sure
what to do from here.

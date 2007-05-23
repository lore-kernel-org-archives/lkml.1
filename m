Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXEWXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXEWXES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXEWXEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:04:08 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:12066 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXEWXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=YscuIdwoL2lro5zb+3PqR9hD1kMgQ+gndN7Hb/yOihvab4K0C+YYLUEiuTkQ0VwzK34B3oVdMgoW0eNs49s8ZzH7eG5DgF8SG5z2VfTLdtYMzaKoK3kW+owI7yRHkUqiJjqHdw1Gkt4dPrlUF1Wq+GxC/PYw80rnTFd56d3tXEM=
Message-ID: <4654C85B.6060505@gmail.com>
Date: Thu, 24 May 2007 03:03:55 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>	<4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com>
In-Reply-To: <adazm3v89hv.fsf@cisco.com>
Content-Type: multipart/mixed;
 boundary="------------060805020405060208070709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060805020405060208070709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Roland Dreier wrote:
>  > If i uncomment the saa716x_read or write, what i get is a solid freeze
>  > on module load. If i leave it commented out, the module loads fine.
> 
> That sounds like a typical bug during driver development... you're
> probably wedging the hardware by doing the wrong access.
> 
> I didn't see the source for saa716x_read or write in the code you
> posted, so it's hard to say if there's a problem with them.
> 

Attaching saa716x_read/write in saa716x_priv.h

> Is your interrupt handler getting called?  Is the device generating
> interrupts?

It looks so, from the logs. The only problem is i can't disable the
interrupts, if i write "0" to 0x500, the interrupt/enable register, it
gives me a solid freeze. If i read from the handler, commenting out the
disable interrupts in init, that read also gives me a solid freeze. This
lead me to think that there could be some problem with the MMIO block
access.


May 23 03:25:48 manu-04 kernel: [  383.602737] saa716x_pci_init: found a
Twinhan VP-6090 device
May 23 03:25:48 manu-04 kernel: [  383.602764] ACPI: PCI Interrupt
0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 23 03:25:48 manu-04 kernel: [  383.603020]      SAA7160/1/2 Rev 1
[1822:0027], irq: 16, latency: 0
May 23 03:25:48 manu-04 kernel: [  383.603024]      memory: 0x32200000,
mmio: 0xe046e000
May 23 03:25:48 manu-04 kernel: [  383.610761] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.624056] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.637348] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.650650] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.663951] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.677253] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.690554] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.703858] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.717156] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.730459] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.743760] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.757064] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.770364] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.783665] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.796966] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.810269] === Interrupts[0010] [] ==
May 23 03:25:48 manu-04 kernel: [  383.823569] === Interrupts[0010] [] ==


> 
>  > That part is then fine. Does MSI require any special tinkering ?
> 
> Just pci_enable_msi() as usual.

Thanks


Regards,
Manu


--------------060805020405060208070709
Content-Type: text/plain;
 name="saa716x_priv.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="saa716x_priv.h"

#ifndef __SAA716x_PRIV_H
#define __SAA716x_PRIV_H

#include <linux/interrupt.h>
#include <linux/pci.h>
#include <linux/sched.h>
#include <linux/mutex.h>
#include "dvbdev.h"
#include "dvb_demux.h"
#include "dmxdev.h"
#include "dvb_frontend.h"
#include "dvb_net.h"

#define SAA716x_ERROR			0
#define SAA716x_NOTICE			1
#define SAA716x_INFO			2
#define SAA716x_DEBUG			3

#define dprintk(x, y, z, format, arg...) do {							\
	if (z) {										\
		if ((x > SAA716x_ERROR) && (x > y))						\
			printk(KERN_ERR "%s (%d): " format "\n", __func__, saa716x->num, ##arg);\
		else if ((x > SAA716x_NOTICE) && (x > y))					\
			printk(KERN_ERR "%s (%d): " format "\n", __func__, saa716x->num, ##arg);\
		else if ((x > SAA716x_INFO) && (x > y))						\
			printk(KERN_ERR "%s (%d): " format "\n", __func__, saa716x->num, ##arg);\
		else if ((x > SAA716x_DEBUG) && (x > y))					\
			printk(KERN_ERR "%s (%d): " format "\n", __func__, saa716x->num, ##arg);\
	} else {										\
		if (x > y)									\
			printk(format, ##arg);							\
	}											\
} while (0);


#define MAKE_ENTRY(subven, subdev, configptr) {			\
		.vendor		= 0x1131,			\
		.device		= 0x7162,			\
		.subvendor	= (subven),			\
		.subdevice	= (subdev),			\
		.driver_data	= (unsigned long) (configptr)	\
}

#define saa716x_write(dat, addr)	writel((dat), (saa716x->mmio)+(addr))
#define saa716x_read(addr)		readl((saa716x->mmio)+(addr))

struct saa716x;

typedef int (*saa716x_load_config_t)(struct saa716x *saa716x);

struct saa716x_hwconfig {
	char 			*model_name;
	char			*dev_type;
	saa716x_load_config_t	load_config;
};

struct saa716x_dma {
	struct tasklet_struct 	dma_tasklet;
};

struct saa716x_dvb {
	struct dvb_adapter	adapter;
	struct dvb_frontend	*fe;
	struct dvb_demux	demux;
	struct dmxdev		dmxdev;
	struct dmx_frontend	fe_hw;
	struct dmx_frontend	fe_mem;
	struct dvb_net		dvbnet;
};

struct saa716x_i2c {
	struct device		*dev;
	struct i2c_adapter	adapter;
	wait_queue_head_t	i2c_queue;
};

struct saa716x {
	/* dev priv */
	unsigned int		verbose;
	unsigned int 		num;
	struct saa716x_hwconfig	*hwconfig;

	/* PCI */
	struct pci_dev		*pdev;
	void __iomem		*mmio;
	unsigned int		irq;

	/* I2C */
	struct saa716x_i2c	i2c_adapter_a;
	struct saa716x_i2c	i2c_adapter_b;

	/* DMA */
	struct saa716x_dma	dma_device_a;
	struct saa716x_dma	dma_device_b;

	/* DVB */
	struct saa716x_dvb	dvb_device_a;
	struct saa716x_dvb	dvb_device_b;
};

extern void saa716x_i2c_disable(struct saa716x *saa716x);
extern void saa716x_i2c_enable(struct saa716x *saa716x);

extern int saa716x_pcie_init(struct saa716x *saa716x);
extern void saa716x_pcie_exit(struct saa716x *saa716x);

#endif //__SAA716x_PRIV_H

--------------060805020405060208070709--

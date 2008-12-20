Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbYLUVRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbYLUVRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYLUVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:17:24 -0500
Received: from mail.work.de ([212.12.32.20]:56809 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYLUVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:17:22 -0500
Message-ID: <494D5FF7.50807@gmail.com>
Date: Sun, 21 Dec 2008 01:13:27 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: MSI messages
References: <49438290.1080502@gmail.com> <20081214081210.GC13371@colo.lackof.org> <4944EAC3.1020407@gmail.com> <20081214185239.GA2039@colo.lackof.org>
In-Reply-To: <20081214185239.GA2039@colo.lackof.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sun, Dec 14, 2008 at 03:15:15PM +0400, Manu Abraham wrote:
> ...
>>> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
>>> the MSI-X table. Driver then calls request_irq() to bind an interrupt
>>> handler to each GSI. So the driver never directly sees the "message".
>> Oh, you mean the array of irq_handlers in the MSI-X table should 
>> correspond to a particular message ?
> 
> No. I mean each MSI-X entry has an address+message pair and each MSI-X entry
> is associated with the parameters passed to each call of request_irq().
> Pass in unique private data to each call of request_irq() and the driver
> can determine which message was delivered when the ISR gets called.
> (ISR == Interrupt Service Routine, aka driver IRQ handler)


Is it possible that even when the config space says that multiple messages 
are supported, you cannot enable MSI-X ?

To explain what i mean here, from the logs in the 3 modes of operation 
MSI-X, MSI, INTx, when i am requesting MSI-X mode, i find that the MSI-X 
mode doesn't get enabled. Is this something that's supposed to be ?

The codebase that generates the logs is http://jusst.de/hg/saa716x
the module that causes it is the saa716x module @ linux/drivers/media/dvb/saa716x

Regards,
Manu


 ------------- with MSI-X -------------

saa716x_pci_init (0): found a NEMO reference board PCIe card
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:05:00.0 to 64
saa716x_request_irq (0): Using MSI-X mode
saa716x_enable_msix (0): MSI-X request failed
saa716x_request_irq (0): INT-A Mode
    SAA7160 Rev 1 [1131:0000], irq: 19,
    mmio: 0xf9480000
    SAA7160 64Bit, MSI Disabled, MSI-X=32 msgs
saa716x_getbootscript_setup (0): Domain 0: Clk PSS <0x218> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 1: Clk DCS <0x21c> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 2: Clk SPI <0x220> Divider: 0x7f825 --> N=1, M=5, freq=500
saa716x_getbootscript_setup (0): Domain 3: Clk I2C/Boot <0x224> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 4: Clk PHI <0x228> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 5: Clk VI0 <0x22c> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 6: Clk VI1 <0x230> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 7: Clk FGPI0 <0x234> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 8: Clk FGPI1 <0x238> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 9: Clk FGPI2 <0x23c> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 10: Clk FGPI3 <0x240> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 11: Clk AI0 <0x244> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 12: Clk AI1 <0x248> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 13: Clk Phy <0x24c> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_core_boot (0): Using External Boot from config
saa716x_hybrid_pci_probe (0): SAA716x Core Boot Success
saa716x_msi_init (0): Initializing MSI ..
saa716x_msi_init (0): Interrupts ena_l <00> ena_h <00> sta_l <00> sta_h <00>
saa716x_jetpack_init (0): SAA7160 Jetpack Successfully initialized
saa716x_i2c_init (0): Initializing SAA7160 I2C Core
saa716x_i2c_init (0): Initializing adapter (0) SAA716x I2C Core 0
saa716x_i2c_init (0): Initializing Adapter (0) SAA716x I2C Core 0 @ 100k
saa716x_add_irqvector (0): Adding Vector 49 <I2CINT_0>
saa716x_add_irqvector (0): Interrupts ena_l <00> ena_h <20000>
saa716x_i2c_init (0): Initializing adapter (1) SAA716x I2C Core 1
saa716x_hybrid_pci_irq (0): MSI STAT L=<00> H=<20000>, CTL L=<00> H=<20000>
saa716x_msi_event: MSI event <I2CINT_0> Bus(0) I2C event: Status=<Idle> --> Stat=<00> Mask=<c7>
saa716x_i2c_init (0): Initializing Adapter (1) SAA716x I2C Core 1 @ 100k
saa716x_add_irqvector (0): Adding Vector 50 <I2CINT_1>
saa716x_add_irqvector (0): Interrupts ena_l <00> ena_h <60000>
saa716x_i2c_init (0): SAA7160 I2C Core succesfully initialized
saa716x_hybrid_pci_irq (0): MSI STAT L=<00> H=<40000>, CTL L=<00> H=<60000>
saa716x_msi_event: MSI event <I2CINT_1> Bus(1) I2C event: Status=<Idle> --> Stat=<00> Mask=<c7>
saa716x_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (SAA716x dvb adapter)
saa716x_dvb_init (0): dvb_dmx_init
saa716x_dvb_init (0): dvb_dmxdev_init
saa716x_dvb_init (0): Frontend Init
saa716x_frontend_power (0): Adapter (0) Power ON
saa716x_frontend_reset (0): Adapter (0) RESET
saa716x_nemo_frontend_attach (0): Adapter (0) SAA716x frontend Init
saa716x_nemo_frontend_attach (0): Adapter (0) Device ID=00                                                     



 ------------- with MSI -------------


saa716x_pci_init (0): found a NEMO reference board PCIe card
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:05:00.0 to 64
saa716x_request_irq (0): Using MSI mode
    SAA7160 Rev 1 [1131:0000], irq: 215,
    mmio: 0xf9480000
    SAA7160 64Bit, MSI Enabled, MSI-X=32 msgs
saa716x_getbootscript_setup (0): Domain 0: Clk PSS <0x218> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 1: Clk DCS <0x21c> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 2: Clk SPI <0x220> Divider: 0x7f825 --> N=1, M=5, freq=500
saa716x_getbootscript_setup (0): Domain 3: Clk I2C/Boot <0x224> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 4: Clk PHI <0x228> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 5: Clk VI0 <0x22c> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 6: Clk VI1 <0x230> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 7: Clk FGPI0 <0x234> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 8: Clk FGPI1 <0x238> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 9: Clk FGPI2 <0x23c> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 10: Clk FGPI3 <0x240> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 11: Clk AI0 <0x244> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 12: Clk AI1 <0x248> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 13: Clk Phy <0x24c> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_core_boot (0): Using External Boot from config
saa716x_hybrid_pci_probe (0): SAA716x Core Boot Success
saa716x_msi_init (0): Initializing MSI ..
saa716x_msi_init (0): Interrupts ena_l <00> ena_h <00> sta_l <00> sta_h <00>
saa716x_jetpack_init (0): SAA7160 Jetpack Successfully initialized
saa716x_i2c_init (0): Initializing SAA7160 I2C Core
saa716x_i2c_init (0): Initializing adapter (0) SAA716x I2C Core 0
saa716x_i2c_init (0): Initializing Adapter (0) SAA716x I2C Core 0 @ 100k
saa716x_add_irqvector (0): Adding Vector 49 <I2CINT_0>
saa716x_add_irqvector (0): Interrupts ena_l <00> ena_h <20000>
saa716x_i2c_init (0): Initializing adapter (1) SAA716x I2C Core 1
irq 64, desc: c0483e80, depth: 1, count: 0, unhandled: 0
->handle_irq():  c01550f9, handle_bad_irq+0x0/0x1a5
->chip(): c0456030, no_irq_chip+0x0/0x40
->action(): 00000000
  IRQ_DISABLED set
unexpected IRQ trap at vector 40
saa716x_i2c_init (0): Initializing Adapter (1) SAA716x I2C Core 1 @ 100k
saa716x_add_irqvector (0): Adding Vector 50 <I2CINT_1>
saa716x_add_irqvector (0): Interrupts ena_l <00> ena_h <60000>
saa716x_i2c_init (0): SAA7160 I2C Core succesfully initialized
irq 64, desc: c0483e80, depth: 1, count: 0, unhandled: 0
->handle_irq():  c01550f9, handle_bad_irq+0x0/0x1a5
->chip(): c0456030, no_irq_chip+0x0/0x40
->action(): 00000000
  IRQ_DISABLED set
unexpected IRQ trap at vector 40
saa716x_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (SAA716x dvb adapter)
saa716x_dvb_init (0): dvb_dmx_init
saa716x_dvb_init (0): dvb_dmxdev_init
saa716x_dvb_init (0): Frontend Init
saa716x_frontend_power (0): Adapter (0) Power ON
saa716x_frontend_reset (0): Adapter (0) RESET
saa716x_nemo_frontend_attach (0): Adapter (0) SAA716x frontend Init
saa716x_nemo_frontend_attach (0): Adapter (0) Device ID=00


 -------------with INTx -------------

saa716x_pci_init (0): found a NEMO reference board PCIe card
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:05:00.0 to 64
    SAA7160 Rev 1 [1131:0000], irq: 19,
    mmio: 0xf9480000
    SAA7160 64Bit, MSI Disabled, MSI-X=32 msgs
saa716x_getbootscript_setup (0): Domain 0: Clk PSS <0x218> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 1: Clk DCS <0x21c> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 2: Clk SPI <0x220> Divider: 0x7f825 --> N=1, M=5, freq=500
saa716x_getbootscript_setup (0): Domain 3: Clk I2C/Boot <0x224> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 4: Clk PHI <0x228> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_getbootscript_setup (0): Domain 5: Clk VI0 <0x22c> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 6: Clk VI1 <0x230> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 7: Clk FGPI0 <0x234> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 8: Clk FGPI1 <0x238> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 9: Clk FGPI2 <0x23c> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 10: Clk FGPI3 <0x240> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 11: Clk AI0 <0x244> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 12: Clk AI1 <0x248> Divider: 0x7f84d --> N=1, M=10, freq=250
saa716x_getbootscript_setup (0): Domain 13: Clk Phy <0x24c> Divider: 0x7f80d --> N=1, M=2, freq=1250
saa716x_core_boot (0): Using External Boot from config
saa716x_hybrid_pci_probe (0): SAA716x Core Boot Success
saa716x_msi_init (0): Initializing MSI ..
saa716x_msi_init (0): Interrupts ena_l <00> ena_h <00> sta_l <00> sta_h <00>
saa716x_jetpack_init (0): SAA7160 Jetpack Successfully initialized
saa716x_i2c_init (0): Initializing SAA7160 I2C Core
saa716x_i2c_init (0): Initializing adapter (0) SAA716x I2C Core 0
saa716x_i2c_init (0): Initializing Adapter (0) SAA716x I2C Core 0 @ 100k
saa716x_add_irqvector (0): Adding Vector 49 <I2CINT_0>
saa716x_add_irqvector (0): Interrupts ena_l <00> ena_h <20000>
saa716x_i2c_init (0): Initializing adapter (1) SAA716x I2C Core 1
saa716x_hybrid_pci_irq (0): MSI STAT L=<00> H=<20000>, CTL L=<00> H=<20000>
saa716x_msi_event: MSI event <I2CINT_0> Bus(0) I2C event: Status=<Idle> --> Stat=<00> Mask=<c7>
saa716x_i2c_init (0): Initializing Adapter (1) SAA716x I2C Core 1 @ 100k
saa716x_add_irqvector (0): Adding Vector 50 <I2CINT_1>
saa716x_add_irqvector (0): Interrupts ena_l <00> ena_h <60000>
saa716x_i2c_init (0): SAA7160 I2C Core succesfully initialized
saa716x_hybrid_pci_irq (0): MSI STAT L=<00> H=<40000>, CTL L=<00> H=<60000>
saa716x_msi_event: MSI event <I2CINT_1> Bus(1) I2C event: Status=<Idle> --> Stat=<00> Mask=<c7>
saa716x_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (SAA716x dvb adapter)
saa716x_dvb_init (0): dvb_dmx_init
saa716x_dvb_init (0): dvb_dmxdev_init
saa716x_dvb_init (0): Frontend Init
saa716x_frontend_power (0): Adapter (0) Power ON
saa716x_frontend_reset (0): Adapter (0) RESET
saa716x_nemo_frontend_attach (0): Adapter (0) SAA716x frontend Init
saa716x_nemo_frontend_attach (0): Adapter (0) Device ID=00 




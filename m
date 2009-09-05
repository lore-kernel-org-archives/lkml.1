Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZIEOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZIEOrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 10:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZIEOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 10:47:16 -0400
Received: from fifo99.com ([67.223.236.141]:48394 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZIEOrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 10:47:16 -0400
Subject: Re: [RFC][PATCH 2/2] disable boot interrupts on Intel X58 and 55x0
From: Daniel Walker <dwalker@fifo99.com>
To: Stefan Assmann <sassmann@redhat.com>
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, Olaf.Dabrunz@gmx.net, ktokunag@redhat.com,
       tglx@linutronix.de, lenb@kernel.org
In-Reply-To: <4AA22A6F.30003@redhat.com>
References: <20090904165525.26294.31112.sendpatchset@t500>
	 <20090904165545.26294.94612.sendpatchset@t500>
	 <1252084019.22928.39.camel@desktop>  <4AA22A6F.30003@redhat.com>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 07:47:20 -0700
Message-Id: <1252162040.6877.7.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 11:07 +0200, Stefan Assmann wrote:
> On 04.09.2009 19:06, Daniel Walker wrote:
> > On Fri, 2009-09-04 at 12:55 -0400, Stefan Assmann wrote:
> >> + * Disable boot interrupts on Intel X58, 55x0 (Tylersburg).
> >> + * See Intel document #321328-001, section 19.10.2.27.
> >> + * (Disable PCI INTx Routing to ICH)
> >> + */
> >> +#define INTEL_X58_55x0_QPIPINTRC_OFFSET        0xe0
> >> +#define INTEL_X58_55x0_QPIPINTRC_BIT   (1<<25)
> >> +static void quirk_disable_intel_tylersburg_boot_interrupt(struct
> >> pci_dev *dev)
> >> +{
> >> +       u32 pci_config_dword;
> >> +
> >> +       if (noioapicquirk)
> >> +               return;
> >> +
> >> +       pci_read_config_dword(dev, INTEL_X58_55x0_QPIPINTRC_OFFSET,
> >> &pci_config_dword);
> >> +       pci_config_dword |= INTEL_X58_55x0_QPIPINTRC_BIT;
> >> +       pci_write_config_dword(dev, INTEL_X58_55x0_QPIPINTRC_OFFSET,
> >> pci_config_dword);
> >> +
> >> +       printk(KERN_INFO "disabled boot interrupt on device 0x%04x:0x%
> >> 04x\n",
> >> +               dev->vendor, dev->device);
> >> +}
> >> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_QPI_TBG15,  quirk_disable_intel_tylersburg_boot_interrupt);
> >> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,  PCI_DEVICE_ID_INTEL_QPI_TBG15,  quirk_disable_intel_tylersburg_boot_interrupt);
> > 
> > 
> > These lines are wildly long .. Could you reduce these down to a max of
> > 80 characters..
> 
> Hi Daniel,
> 
> you're right about the lines being to long, however if you take a peek
> at drivers/pci/quirks.c you'll see that all the quirks are done this
> way. :)

I looked, the whole thing is a mess .. Really all these lines need to be
cleaned up.. It doesn't help to have you add more to it tho. Especially
the tab's or spaces between the commas, I can say I understand why that
is.. If there is a good reason why it's like that I'm all ears..

Daniel


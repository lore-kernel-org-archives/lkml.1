Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbZIEJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbZIEJJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbZIEJJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 05:09:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbZIEJJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 05:09:18 -0400
Message-ID: <4AA22A6F.30003@redhat.com>
Date: Sat, 05 Sep 2009 11:07:59 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, Olaf.Dabrunz@gmx.net, ktokunag@redhat.com,
       tglx@linutronix.de, lenb@kernel.org
Subject: Re: [RFC][PATCH 2/2] disable boot interrupts on Intel X58 and 55x0
References: <20090904165525.26294.31112.sendpatchset@t500>	 <20090904165545.26294.94612.sendpatchset@t500> <1252084019.22928.39.camel@desktop>
In-Reply-To: <1252084019.22928.39.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.09.2009 19:06, Daniel Walker wrote:
> On Fri, 2009-09-04 at 12:55 -0400, Stefan Assmann wrote:
>> + * Disable boot interrupts on Intel X58, 55x0 (Tylersburg).
>> + * See Intel document #321328-001, section 19.10.2.27.
>> + * (Disable PCI INTx Routing to ICH)
>> + */
>> +#define INTEL_X58_55x0_QPIPINTRC_OFFSET        0xe0
>> +#define INTEL_X58_55x0_QPIPINTRC_BIT   (1<<25)
>> +static void quirk_disable_intel_tylersburg_boot_interrupt(struct
>> pci_dev *dev)
>> +{
>> +       u32 pci_config_dword;
>> +
>> +       if (noioapicquirk)
>> +               return;
>> +
>> +       pci_read_config_dword(dev, INTEL_X58_55x0_QPIPINTRC_OFFSET,
>> &pci_config_dword);
>> +       pci_config_dword |= INTEL_X58_55x0_QPIPINTRC_BIT;
>> +       pci_write_config_dword(dev, INTEL_X58_55x0_QPIPINTRC_OFFSET,
>> pci_config_dword);
>> +
>> +       printk(KERN_INFO "disabled boot interrupt on device 0x%04x:0x%
>> 04x\n",
>> +               dev->vendor, dev->device);
>> +}
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_QPI_TBG15,  quirk_disable_intel_tylersburg_boot_interrupt);
>> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,  PCI_DEVICE_ID_INTEL_QPI_TBG15,  quirk_disable_intel_tylersburg_boot_interrupt);
> 
> 
> These lines are wildly long .. Could you reduce these down to a max of
> 80 characters..

Hi Daniel,

you're right about the lines being to long, however if you take a peek
at drivers/pci/quirks.c you'll see that all the quirks are done this
way. :)

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera

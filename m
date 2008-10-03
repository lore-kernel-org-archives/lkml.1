Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYJCSN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYJCSN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYJCSNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:13:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40577 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYJCSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WIHVjdLBZOU/WncQurQDqV7wSxMDmvEVp2JA1k6qFUY2GTrwEo3UyMU6meuEzhVKfX
         rVBWAoJ1y31lPvugASmhd3j53E5LNhsFuKxe6S3Rr7B4pfYgUUNy2FVGeU3+20l+GPWY
         w6uOw1rN/YYevyzweBlQ/fNMBPCK4ojNIYtnI=
Message-ID: <4727185d0810031113w2967fef7qa102d6ec4a89311e@mail.gmail.com>
Date: Fri, 3 Oct 2008 20:13:14 +0200
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4727185d0810030214t69666ea4qa2e9960283406270@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com>
	 <200810021146.28704.jbarnes@virtuousgeek.org>
	 <200810021259.05864.bjorn.helgaas@hp.com>
	 <4727185d0810030214t69666ea4qa2e9960283406270@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 11:14 AM, Vincent Legoll
<vincent.legoll@gmail.com> wrote:
> On Thu, Oct 2, 2008 at 8:59 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>> On Thursday 02 October 2008 12:46:28 pm Jesse Barnes wrote:
>>> Bjorn, how does this jive with the various other debug harmonization patches
>>> you've been putting together & reviewing?
>>
>> I think it's great.  The only nit I would change is to use
>> "[%#llx-%#llx]" as we do in pci_request_region().
>>
>> Bjorn
>
> Thanks for the review, I'll post an updated version this evening.

Here is the updated version, with an extra case from drivers/pci/pcie/aspm.c,
please review for the slight wording change in the message. It's currently
running, so is partly tested (It didn't ran through all cases on my HW)

Producing the following dmesg extract:

[    0.330756] pci 0000:00:02.0: reg 10 32bit mmio: [0xf4200000-0xf427ffff]
[    0.330762] pci 0000:00:02.0: reg 14 io port: [0xe100-0xe107]
[    0.330768] pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]
[    0.330773] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf4000000-0xf40fffff]
[    0.330875] pci 0000:00:1a.0: reg 20 io port: [0xe200-0xe21f]
[    0.330953] pci 0000:00:1a.1: reg 20 io port: [0xe600-0xe61f]
[    0.331025] pci 0000:00:1a.2: reg 20 io port: [0xe000-0xe01f]
[    0.331090] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4285000-0xf42853ff]
[    0.331179] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4280000-0xf4283fff]
[    0.331222] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.332010] pci 0000:00:1b.0: PME# disabled
[    0.332165] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.332256] pci 0000:00:1c.0: PME# disabled
[    0.332401] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.333004] pci 0000:00:1c.3: PME# disabled
[    0.333146] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.333238] pci 0000:00:1c.4: PME# disabled
[    0.333417] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.333495] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.333571] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.333637] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4284000-0xf42843ff]
[    0.333820] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
ICH6 ACPI/GPIO/TCO
[    0.334004] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.334152] pci 0000:00:1f.2: reg 10 io port: [0xe700-0xe707]
[    0.334159] pci 0000:00:1f.2: reg 14 io port: [0xe800-0xe803]
[    0.334165] pci 0000:00:1f.2: reg 18 io port: [0xe900-0xe907]
[    0.334172] pci 0000:00:1f.2: reg 1c io port: [0xea00-0xea03]
[    0.334178] pci 0000:00:1f.2: reg 20 io port: [0xeb00-0xeb1f]
[    0.334185] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4286000-0xf42867ff]
[    0.334212] pci 0000:00:1f.2: PME# supported from D3hot
[    0.334301] pci 0000:00:1f.2: PME# disabled
[    0.334449] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf4287000-0xf42870ff]
[    0.334465] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.334538] pci 0000:00:1c.0: bridge io port: [0xa000-0xafff]
[    0.334655] pci 0000:02:00.0: reg 24 32bit mmio: [0xf4100000-0xf4101fff]
[    0.334688] pci 0000:02:00.0: PME# supported from D3hot
[    0.334779] pci 0000:02:00.0: PME# disabled
[    0.334909] pci 0000:02:00.1: reg 10 io port: [0xb000-0xb007]
[    0.334919] pci 0000:02:00.1: reg 14 io port: [0xb100-0xb103]
[    0.334929] pci 0000:02:00.1: reg 18 io port: [0xb200-0xb207]
[    0.335006] pci 0000:02:00.1: reg 1c io port: [0xb300-0xb303]
[    0.335015] pci 0000:02:00.1: reg 20 io port: [0xb400-0xb40f]
[    0.335089] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe
device. It can be enabled forcedly with 'pcie_aspm=force'
[    0.335282] pci 0000:00:1c.3: bridge io port: [0xb000-0xbfff]
[    0.335286] pci 0000:00:1c.3: bridge 32bit mmio: [0xf4100000-0xf41fffff]
[    0.335365] pci 0000:03:00.0: reg 10 io port: [0xc000-0xc0ff]
[    0.335390] pci 0000:03:00.0: reg 18 64bit mmio: [0xf1000000-0xf1000fff]
[    0.335415] pci 0000:03:00.0: reg 30 32bit mmio: [0x0-0x1ffff]
[    0.336044] pci 0000:03:00.0: supports D1
[    0.336046] pci 0000:03:00.0: supports D2
[    0.336048] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.336145] pci 0000:03:00.0: PME# disabled
[    0.336250] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe
device. It can be enabled forcedly with 'pcie_aspm=force'
[    0.337041] pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]
[    0.337046] pci 0000:00:1c.4: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.337111] pci 0000:04:00.0: reg 10 io port: [0xd000-0xd01f]
[    0.338077] pci 0000:04:00.1: reg 10 io port: [0xd100-0xd107]
[    0.338170] pci 0000:04:01.0: reg 10 io port: [0xd200-0xd207]
[    0.338178] pci 0000:04:01.0: reg 14 io port: [0xd300-0xd303]
[    0.338185] pci 0000:04:01.0: reg 18 io port: [0xd400-0xd407]
[    0.338192] pci 0000:04:01.0: reg 1c io port: [0xd500-0xd503]
[    0.338200] pci 0000:04:01.0: reg 20 io port: [0xd600-0xd60f]
[    0.338207] pci 0000:04:01.0: reg 24 32bit mmio: [0xf3000000-0xf30000ff]
[    0.338215] pci 0000:04:01.0: reg 30 32bit mmio: [0x0-0x7ffff]
[    0.338231] pci 0000:04:01.0: supports D1
[    0.338233] pci 0000:04:01.0: supports D2
[    0.338279] pci 0000:00:1e.0: transparent bridge
[    0.338366] pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
[    0.338370] pci 0000:00:1e.0: bridge 32bit mmio: [0xf2000000-0xf3ffffff]

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>

-- 
Vincent Legoll

---

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 851f5b8..9675dc3 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -528,9 +528,9 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		pci_read_config_dword(child_dev, child_pos + PCI_EXP_DEVCAP,
 			&reg32);
 		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
-			printk("Pre-1.1 PCIe device detected, "
-				"disable ASPM for %s. It can be enabled forcedly"
-				" with 'pcie_aspm=force'\n", pci_name(pdev));
+			dev_printk(KERN_INFO, &child_dev->dev, "disabling ASPM"
+				" on pre-1.1 PCIe device. It can be enabled"
+				" forcedly with 'pcie_aspm=force'\n");
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 36698e5..0ae65bf 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -304,8 +304,9 @@ static int __pci_read_base(struct pci_dev *dev,
enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
-				pci_name(dev), pos, (unsigned long long)res->start,
+			dev_printk(KERN_DEBUG, &dev->dev,
+				"reg %x 64bit mmio: [%#llx-%#llx]\n", pos,
+				(unsigned long long)res->start,
 				(unsigned long long)res->end);
 		}
 	} else {
@@ -316,8 +317,8 @@ static int __pci_read_base(struct pci_dev *dev,
enum pci_bar_type type,

 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
-			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: [%#llx-%#llx]\n", pos,
+			(res->flags & IORESOURCE_IO) ? "io port" : "32bit mmio",
 			(unsigned long long)res->start, (unsigned long long)res->end);
 	}

@@ -389,8 +390,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: [%#llx-%#llx]\n",
+			(unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}

@@ -403,8 +404,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: [%#llx-%#llx]\n",
+			(unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}

@@ -441,8 +442,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
-			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: [%#llx-%#llx]\n",
+			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 }

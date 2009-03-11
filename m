Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZCKQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZCKQqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZCKQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:46:01 -0400
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:36594 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751790AbZCKQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:46:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 824434.74892.bm@omp109.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=nIQf8xrZrLcJxGKvNsgTjWxgmwggvXm3Pngt1awFncPiyjhgh5Mmv22n7l1hnRw6oaqWIDfwMqi7D7U3sZ0T1xyu5a6aekSxsafunStfspcVK/7TwY9HI5fMnmGThYBt98Do8eeotDpP8lTr4jFHBDW0l2AMMlQFN3OxfZbT9jg=;
Message-ID: <708656.28228.qm@web112203.mail.gq1.yahoo.com>
X-YMail-OSG: 9TiTBusVM1krbTh7FvP5NhYpNnDVGyGKeZqfg9wba14vmeYM3D83pRK.gmpibNRjqH5sBCV0DgotVhYl15LEhCiK_5iR34QTN50lnbAjjhnyrQsMXN0qjFP8J2mObIchKRlri9n.AXylYrApKD.CmOs_wFF5dzRIYLUcu6pPVX2YYwoR0qoSI367OHs3RPtQ.GSZQI.4bKGF3VPGV8YSfPsf7zi6zP9hv398F9ap.I3yAeVQ.iZCQNemMmmHhKsaxuMjqkCAATV.hnSBrMAFxz1QQd17n_c.kZ2TMqpl.ZoeLW2Ac3.eM5GPAQ--
X-Mailer: YahooMailClassic/5.1.19 YahooMailWebService/0.7.289.1
Date: Wed, 11 Mar 2009 09:45:58 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: kernel regression ref networking
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I reported since 2.6.27 that there has any kernel regression, because networking isn't working with ethernet cards, on all my computers, I supposed the problem has to do with some new features or parameters of the kernel config.

Meanwhile I found more narrow what can be the reason.   For example, last night I compiled 2.6.29-rc7-git4 one time with an 'old' configuration sucessful since 2.6.29-rc6-git5, where internet / eth-cards still are working, and with a slightly changed new config, where it's not more working.

Below the differences between the two configs.   One of these different parameters / new features causes that internet / eth dont work more at all, beginning with that ping 192.168.1.1 (modem directly connected with the computer via eth0) dont get response.

With this, someone of the specialists perhaps can quickly see what of the new parameters / options causes the total inoperability of networking, and throw this new feature out from the kernel, because its completely useless.

It should be something included at the time of 2.6.27 because at that time the problem begun. 


Werner Landgraf
w.landgraf@yahoo.com

Linux SYS : http://ftp.tu-chemnitz.de/pub/linux/SYS/
===========

3,4c3,4
< # Linux kernel version: 2.6.29-rc6-git5
< # Sat Feb 28 05:46:44 2009
---
> # Linux kernel version: 2.6.29-rc7-git4
> # Wed Mar 11 01:53:24 2009
98a99
> CONFIG_ANON_INODES=y
109d109
< CONFIG_COMPAT_BRK=y
112d111
< CONFIG_ANON_INODES=y
121a121
> CONFIG_COMPAT_BRK=y
184c184
< # CONFIG_X86_RDC321X is not set
---
> CONFIG_X86_RDC321X=y
186c186,192
< # CONFIG_PARAVIRT_GUEST is not set
---
> CONFIG_PARAVIRT_GUEST=y
> CONFIG_VMI=y
> CONFIG_KVM_CLOCK=y
> CONFIG_KVM_GUEST=y
> CONFIG_LGUEST_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_CLOCK=y
250c256
< # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
---
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
289c295,296
< # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
---
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
347c354
< # CONFIG_ACPI_SBS is not set
---
> CONFIG_ACPI_SBS=m
423c430
< # CONFIG_PCI_MSI is not set
---
> CONFIG_PCI_MSI=y
434c441,443
< # CONFIG_MCA is not set
---
> CONFIG_MCA=y
> CONFIG_MCA_LEGACY=y
> CONFIG_MCA_PROC_FS=y
468c477,479
< # CONFIG_HOTPLUG_PCI_CPCI is not set
---
> CONFIG_HOTPLUG_PCI_CPCI=y
> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
> CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
1451a1463
> # CONFIG_SCSI_FD_MCS is not set
1455a1468
> # CONFIG_SCSI_IBMMCA is not set
1464a1478
> # CONFIG_SCSI_NCR_D700 is not set
1473a1488
> # CONFIG_SCSI_NCR_Q720 is not set
1687a1703,1704
> # CONFIG_ELMC is not set
> # CONFIG_ELMC_II is not set
1692a1710
> # CONFIG_ULTRAMCA is not set
1726a1745,1746
> # CONFIG_NE2_MCA is not set
> # CONFIG_IBMLANA is not set
1834a1855
> # CONFIG_MADGEMC is not set
2431a2453
> # CONFIG_SERIAL_8250_MCA is not set
2447c2469
< CONFIG_VIRTIO_CONSOLE=m
---
> CONFIG_VIRTIO_CONSOLE=y
2734a2757
> # CONFIG_RDC321X_WDT is not set
4630,4631c4653,4654
< CONFIG_VIRTIO=m
< CONFIG_VIRTIO_RING=m
---
> CONFIG_VIRTIO=y
> CONFIG_VIRTIO_RING=y




      


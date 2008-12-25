Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbYLYGSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbYLYGSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 01:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYLYGSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 01:18:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60068 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLYGSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 01:18:03 -0500
Message-ID: <49532592.9050202@jp.fujitsu.com>
Date: Thu, 25 Dec 2008 15:17:54 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] PCI/MSI: bugfix/utilize for msi_capability_init()
References: <4951F258.6040601@jp.fujitsu.com> <df9815e70812240101q23f6d59fj4121b19563a77d47@mail.gmail.com>
In-Reply-To: <df9815e70812240101q23f6d59fj4121b19563a77d47@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> On Wed, Dec 24, 2008 at 4:27 PM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
>> This patch fix a following bug and does a cleanup.
>>
>> bug:
>>        commit 5993760f7fc75b77e4701f1e56dc84c0d6cf18d5
>>        had a wrong change (since is_64 is boolean[0|1]):
>>
>> -               pci_write_config_dword(dev,
>> -                       msi_mask_bits_reg(pos, is_64bit_address(control)),
>> -                       maskbits);
>> +               pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
>>
> Yes, really a nasty bug. I'm feeling guilty...
> Should this fix hit 2.6.28 release?  I CCed Jesse for his point.

Unfortunately we failed to take this fix into Santa's bag...

Note that this bug affects mask condition after calling pci_enable_msi()
for devices with MSI capability with (optional) per-vector masking support.
Devices with MSI-X or MSI without masking support are safe.
Once unmask/mask_msi_irq() is called, the condition should be fixed.

And the wrong pci_write_config_dword() will have no effects because
target registers (fields in header, such as Vendor ID) are read-only.

Thanks,
H.Seto


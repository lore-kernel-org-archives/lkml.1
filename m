Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0BBVdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:33:53 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:43230 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0BBVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:33:50 -0500
Cc: linux-kernel@vger.kernel.org, jkmair@cs.otago.ac.nz
Message-Id: <D65A73B5-D44A-4AEF-8B0E-35DC119127C9@cs.otago.ac.nz>
From: zhiyi <zhuang@cs.otago.ac.nz>
To: Borislav Petkov <petkovbb@googlemail.com>
In-Reply-To: <20100202070751.GA11623@liondog.tnic>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Date: Wed, 3 Feb 2010 10:33:46 +1300
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz> <20100130171804.GA2348@liondog.tnic> <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz> <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com> <9ea470501002010704m15dfaedau813b7accfd1d22ff@mail.gmail.com> <4086DEE4-5D26-4EED-8353-2C4F54238CAE@cs.otago.ac.nz> <20100202070751.GA11623@liondog.tnic>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/02/2010, at 8:07 PM, Borislav Petkov wrote:

> On Tue, Feb 02, 2010 at 01:49:06PM +1300, zhiyi wrote:
>> The dmesg relevant to nr_cpu_ids of the quad socket is:
>>
>> [    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:32  
>> nr_node_ids:4
>>
>
> No, this is not the relevant info. I was actually looking for the  
> MADT ACPI
> table and whether there are disabled entries like so:
>
> [    0.000000] ACPI: LAPIC (acpi-id[0x03] lapic-id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi-id[0x04] lapic-id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi-id[0x05] lapic-id[0x84] disabled)
> [    0.000000] ACPI: LAPIC (acpi-id[0x06] lapic-id[0x85] disabled)
>
> because if there are, nr_cpu_ids will include those when you don't  
> boot
> with "possible_cpus=N".

Thanks. I understand the problem now. Below is the related message on  
my quad-socket. Not surprisingly nr_cpu_ids should be 32 since the  
machine can potentially accommodate 32 cores.

The good thing is that I realized I should use num_present_cpus()  
instead of nr_cpu_ids for my purpose (get the number of real cores on  
the machine)

Many thanks,
Zhiyi


[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x20] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x21] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x22] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x24] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x25] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x26] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x27] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x28] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x29] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x2a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x2b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x2c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x2d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x2e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x2f] disabled)




>
>
> Anyhow, you can read this for more info: http://www.pubbs.net/kernel/200912/64310/
>
> -- 
> Regards/Gruss,
>    Boris.
>

=======================
Zhiyi Huang
Dept of Computer Science
University of Otago
Email: hzy@cs.otago.ac.nz
Phone: 0064-3-4795680
Fax: 0064-3-4798529


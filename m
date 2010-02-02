Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0BBAtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:49:11 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:51625 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0BBAtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:49:10 -0500
Cc: linux-kernel@vger.kernel.org, Zhiyi Huang <hzy@cs.otago.ac.nz>,
       jkmair@cs.otago.ac.nz
Message-Id: <4086DEE4-5D26-4EED-8353-2C4F54238CAE@cs.otago.ac.nz>
From: zhiyi <zhuang@cs.otago.ac.nz>
To: Borislav Petkov <petkovbb@googlemail.com>
In-Reply-To: <9ea470501002010704m15dfaedau813b7accfd1d22ff@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Date: Tue, 2 Feb 2010 13:49:06 +1300
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz> <20100130171804.GA2348@liondog.tnic> <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz> <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com> <9ea470501002010704m15dfaedau813b7accfd1d22ff@mail.gmail.com>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/02/2010, at 4:04 AM, Borislav Petkov wrote:

> On Mon, Feb 1, 2010 at 2:57 PM, Borislav Petkov <petkovbb@googlemail.com 
> > wrote:
>> On Sun, Jan 31, 2010 at 11:59 PM, zhiyi <zhuang@cs.otago.ac.nz>  
>> wrote:
>>> My module worked for a kernel 2.6.29 with CONFIG_NR_CPUS=64 on my  
>>> dual
>>> quad-core AMD Opteron. The value of nr_cpu_ids I got from the same  
>>> module
>>> was correct (8).
>>
>> This could mean that your include/generated/autoconf.h, which is  
>> used by
>> external modules, is not updated and contains CONFIG_NR_CPUS=8. Do
>>
>> make mrproper
>>
>> in your kernel directory by moving your .config out of the way  
>> first and
>> then rebuild your kernel and external module(s). nr_cpu_ids should  
>> pick
>> up the updated CONFIG_NR_CPUS value from your .config.
>
> That's actually not necessary - the nr_cpu_ids thing is set at compile
> time to CONFIG_NR_CPUS but then capped to a possibly lower value upon
> boot depending on the info in the ACPI mptables. Can you please send  
> the
> .config and the full dmesg of the quadsocket machine?

The dmesg relevant to nr_cpu_ids of the quad socket is:

[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:32 nr_node_ids:4

For comparison purposes, the dmesg for the dual socket is:

[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1

It seems nr_node_ids:1 for the dual socket is not quite right though.

Cheers,
Zhiyi




>
>
> Thanks.
>
> -- 
> Regards/Gruss,
> Boris
>

=======================
Zhiyi Huang
Dept of Computer Science
University of Otago
Email: hzy@cs.otago.ac.nz
Phone: 0064-3-4795680
Fax: 0064-3-4798529


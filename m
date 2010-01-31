Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0AaXnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:43:04 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:49353 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab0AaXnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:43:01 -0500
Cc: linux-kernel@vger.kernel.org, Zhiyi Huang <hzy@cs.otago.ac.nz>,
       jkmair@cs.otago.ac.nz
Message-Id: <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz>
From: zhiyi <zhuang@cs.otago.ac.nz>
To: Borislav Petkov <petkovbb@googlemail.com>
In-Reply-To: <20100130171804.GA2348@liondog.tnic>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Date: Mon, 1 Feb 2010 11:59:44 +1300
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz> <20100130171804.GA2348@liondog.tnic>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,
Thanks for your answer.
However, your answer doesn't fully resolve my puzzle.
My module worked for a kernel 2.6.29 with CONFIG_NR_CPUS=64 on my dual  
quad-core AMD Opteron. The value of nr_cpu_ids I got from the same  
module was correct (8). It seems nr_cpu_ids has nothing to do with  
CONFIG_NR_CPUS.
Cheers,
Zhiyi

On 31/01/2010, at 6:18 AM, Borislav Petkov wrote:

> On Thu, Jan 28, 2010 at 12:16:44PM +1300, zhiyi wrote:
>> Hi,
>> I have just found the value of nr_cpu_ids is 32, instead of 16 on my
>> new Dell PowerEdge R905 which has 16 cpus (4 quad-core Opteron
>> 8380). However, /proc/cpuinfo displays the right number (16).
>> I have searched the archive but found no related subject.  Is there
>> any patch already available to fix the problem?
>> I am using 2.6.31-4 and verified this incorrect value (32) using a
>> module.
>
> nr_cpu_ids is set to CONFIG_NR_CPUS on SMP kernels and denotes the max
> CPUs supported by your kernel. This is not a bug but a configurable
> option in the kernel for saving memory.
>
> You can still set CONFIG_NR_CPUS in "-> Processor type and features"  
> to
> the max number of cores N you have on your machine if you want to save
> approx 8*N KB. But guessing from your quadsocket configuration, memory
> shouldn't be that scarce on that machine to go the trouble :).
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


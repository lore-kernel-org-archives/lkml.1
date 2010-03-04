Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0CDOlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:41:53 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:15979 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372Ab0CDOlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:41:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMJVj0tLd/sX/2dsb2JhbAAHgwLAL5A7gTWCXWoEgxc
X-IronPort-AV: E=Sophos;i="4.49,581,1262581200"; 
   d="scan'208";a="57516758"
Message-ID: <4B8FC6AC.4060801@teksavvy.com>
Date: Thu, 04 Mar 2010 09:41:48 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, foo saa <foosaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
 program
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org> <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
In-Reply-To: <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/10 09:17, Greg Freemyer wrote:
..
> I think / suspect your major problem is you say above that you use a
> 512-byte buffer to wipe with.  The kernel is using 4K pages.  So when
> you write to a 4K section of the drive for the first time, the kernel
> implements read-modify-write logic.
>
> Your i/o failures are almost certainly on the read cycle of the above,
> not the write cycle.  You need to move to 4K buffers and you need to
> ensure your 4K writes are aligned with how the kernel is working with
> the disk.  ie. You need your 4K buffer to perfectly align with the
> kernels 4K block handling so you never have a read-modify-write cycle.
..

You'll also need to disable Linux read-ahead for the drive,
or it may try reading beyond even the 4KB block.

But really.. isn't "hdparm --security-erase NULL /dev/sdX" good enough ???

Cheers

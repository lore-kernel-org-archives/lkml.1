Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbYCSVhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYCSVhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763651AbYCSUIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:08:00 -0400
Received: from ozlabs.org ([203.10.76.45]:39636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763468AbYCSUH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:07:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18400.36670.5918.566965@cargo.ozlabs.ibm.com>
Date: Wed, 19 Mar 2008 14:57:50 +1100
From: Paul Mackerras <paulus@samba.org>
To: skumar@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Poornima Nayak <Poornima.Nayak@in.ibm.com>,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org
Subject: Re: [BUG]2.6.25-rc6:Unable to handle kernel paging request
In-Reply-To: <20080318052921.GA32259@in.ibm.com>
References: <20080318052921.GA32259@in.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudhir Kumar writes:

> Unable to handle kernel paging request for data at address
> 0xd00008000000002e

Looks like some driver tried to access I/O port 0x2e without checking
whether there was possibly anything there first.

> Faulting instruction address: 0xc00000000074ded8
> cpu 0x0: Vector: 300 (Data Access) at [c00000003e073aa0]
>     pc: c00000000074ded8: .f71805f_find+0x44/0x32c
>     lr: c00000000074e1f8: .f71805f_init+0x38/0x194
>     sp: c00000003e073d20
>    msr: 8000000000009032
>    dar: d00008000000002e
>  dsisr: 42000000
>   current = 0xc0000000220851c0
>   paca    = 0xc0000000007c2700
>     pid   = 1, comm = swapper
> enter ? for help
> [c00000003e073dc0] c00000000074e1f8 .f71805f_init+0x38/0x194

Looks like it might be the f71805f driver, whatever that is...
Hmmm, drivers/hwmon/f71805f.c looks like it, and indeed it does go
poking around in PCI I/O space with no checks whatever.

I suggest you turn off CONFIG_SENSORS_F71805F.

It doesn't help, of course, that CONFIG_HWMON defaults to y. :(

Paul.

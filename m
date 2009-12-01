Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZLAO2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZLAO2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZLAO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:28:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:45418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZLAO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:28:40 -0500
In-Reply-To: <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com> <1259665127.2076.363.camel@pasglop> <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through  device tree
Date: Tue, 1 Dec 2009 15:35:55 +0100
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The scenario for the first case is that in a multicore system running
> ASMP which means different OS runs on different cores.  They might
> communicate through a shared memory region.  The region on every OS
> need to be mapped with the same cache perperty to avoid cache paradox.

This isn't true.  In ASMP, you cannot usually do coherency between
the different CPUs at all.  Also, in most PowerPC implementations,
it is fine if one CPU maps a memory range as coherent while another
maps it as non-coherent; sure, you have to be careful or you will
read stale data, but things won't wedge.

> The scenario for the second case is to pre-allocate some memory to a
> certain application or device (probably through mem=XXX kernel
> parameter or limit through device tree).  The memory is not known to
> kernel, but fully managed by the application/device.  We need being
> able to map the region cachable for better performance.

So make the memory known to the kernel, just tell the kernel not to
use it.  If it's normal system RAM, just put it in the "memory" node
and do a memreserve on it (or do something in your platform code); if
it's some other memory, do a device driver for it, map it there.


Segher


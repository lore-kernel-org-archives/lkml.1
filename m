Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZFVW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZFVW1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZFVW1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:27:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:58323 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZFVW1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:27:39 -0400
Subject: Re: Regression: ppc powerstation boot hang caused by slab
 initialisation code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1245708635.17035.6.camel@mulgrave.site>
References: <1245708635.17035.6.camel@mulgrave.site>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 08:27:13 +1000
Message-Id: <1245709633.20062.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 17:10 -0500, James Bottomley wrote:
> I'm getting a boot hang on my powerstation with recent kernels.  It
> hangs in the early prom init code:

It probably goes much further but doesn't get a chance to tell you :-)

I'll dig. Just in case, can you send me your .config ?

Cheers,
Ben.

> Please wait, loading kernel...
>    Elf64 kernel loaded...
> Loading ramdisk...
> ramdisk loaded at 02500000, size: 8280 Kbytes
> OF stdout device is: /ht/isa@8/serial@2f8
> Preparing to boot Linux version 2.6.30 (jejb@claymoor) (gcc version
> 4.3.3 (Debian 4.3.3-10) ) #1 SMP Mon Jun 22 09:59:35 CDT 2009
> command line: root=/dev/sda3 ro console=ttyS0,19200n1 
> memory layout at init:
>   alloc_bottom : 0000000002d16000
>   alloc_top    : 0000000030000000
>   alloc_top_hi : 0000000080000000
>   rmo_top      : 0000000030000000
>   ram_top      : 0000000080000000
> instantiating rtas at 0x000000002fff5000... done
> boot cpu hw idx 0000000000000000
> starting cpu hw idx 0000000000000001... done
> starting cpu hw idx 0000000000000002... done
> starting cpu hw idx 0000000000000003... done
> copying OF device tree...
> Building dt strings...
> Building dt structure...
> Device tree strings 0x0000000003117000 -> 0x0000000003117640
> Device tree struct  0x0000000003118000 -> 0x000000000311b000
> Calling quiesce...
> returning from prom_init
> 
> Git bisect identifies this commit:
> 
> commit 83b519e8b9572c319c8e0c615ee5dd7272856090
> Author: Pekka Enberg <penberg@cs.helsinki.fi>
> Date:   Wed Jun 10 19:40:04 2009 +0300
> 
>     slab: setup allocators earlier in the boot sequence
> 
> So it's something do do with early slab initialisation.  I'll try to
> track it down, but reverting it is hard because it seems to have a chain
> of dependent commits.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


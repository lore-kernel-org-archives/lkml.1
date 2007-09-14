Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbXINNTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbXINNTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbXINNTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:19:01 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37975 "EHLO
	caffeine.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbXINNTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:19:00 -0400
Date: Fri, 14 Sep 2007 09:18:59 -0400
To: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel-Quad on GA-P35-S3 motherboard with 4*2GB
Message-ID: <20070914131859.GC5386@csclub.uwaterloo.ca>
References: <46EA4B50.7040904@dgt.com.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EA4B50.7040904@dgt.com.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 10:50:24AM +0200, Wojciech Kromer wrote:
> I can't see whole 8GB of ram.
> 
> With F2 BIOS release i can only work with kernel param mem=4G.
> After updating to F4 BIOS release I can work with mem=8G, but I see this:
> 
> # free -m
>             total       used       free     shared    buffers     cached
> Mem:          6473        474       5999          0         29        278
> 
> Without mem=8G kernel starts to slow down and hangs while starting 
> filesystem.
> There is no message.
> 
> My whole memory was tested with memtest. Full test took about 48hour. Is 
> it wrong?
> 
> I have:  Intel(R) Core(TM)2 Quad CPU @ 2.40GHz
> There are 4   *  2GB / 667MHz DIMMs.
> 
> 
> # cat /proc/iomem |grep RAM
> 00000000-0009f7ff : System RAM
> 00100000-9fedffff : System RAM
> 100000000-25fffffff : System RAM
> 
> # dmesg|grep BIOS-e820
> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 000000009fee0000 (usable)
> BIOS-e820: 000000009fee0000 - 000000009fee3000 (ACPI NVS)
> BIOS-e820: 000000009fee3000 - 000000009fef0000 (ACPI data)
> BIOS-e820: 000000009fef0000 - 000000009ff00000 (reserved)
> BIOS-e820: 00000000c0000000 - 00000000c4000000 (reserved)
> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> BIOS-e820: 0000000100000000 - 0000000260000000 (usable)
> 
> 
> 
> I can see that higer memory range was remmaped,
> by why accesing something greater than 100000000 is problematic?
> Do I need to change something i kernel configuration?

What does your mtrr look like?  How about dmesg?  Might be the stupid
mtrr setup some bioses have been doing on intel chips where it would do:
4GB range at 4GB
1GB range at 8GB
512MB range at 9GB
256MB range at 9.5GB
etc.

And then it runs out of entries (which pisses of X).

The simple solution would have been to assign an 8GB range at 4GB or
maybe a 4GB range at 4GB and a 2GB range at 8GB to cover all the ram.
Without the mtrr coverage you get no caching of that memory which makes
use that that section of memory slow.  To make the system useable there
is code in the kernel to discard any memory the BIOS didn't correctly
cover with an mtrr cachable entry.

--
Len Sorensen

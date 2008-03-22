Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYCVXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYCVXvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYCVXvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:51:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57350 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbYCVXvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:51:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E59B39.90306@s5r6.in-berlin.de>
Date: Sun, 23 Mar 2008 00:50:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 22 Mar 2008, Linus Torvalds wrote:
>> AND no, I don't think our x86-32 ioremap() actually works for this case, 
>> because while the resource data may have the full 64 bits, when the 
>> ioremap() happens it gets truncated to 32 bits.
> 
> Does this patch make any difference?
> 
> (ENTIRELY untested, I checked that it compiles on x86-64, but didn't even 
> test a 32-bit build, I'm hoping whoever sees this issue can also fix up 
> the inevitable small missed pieces)
> 
> 		Linus
> 
> ---
>  arch/x86/mm/ioremap.c   |    6 +++---
>  include/asm-x86/io_32.h |    6 +++---
>  include/asm-x86/io_64.h |    6 +++---
>  lib/iomap.c             |    2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 8fe576b..4afaba0 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -106,7 +106,7 @@ static int ioremap_change_attr(unsigned long vaddr, unsigned long size,
>   * have to convert them into an offset in a page-aligned mapping, but the
>   * caller shouldn't need to know that small detail.
>   */
> -static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
> +static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
>  			       enum ioremap_mode mode)
[...]

On my x86-32 test system, none of the devices gets an MMIO region above 
the 4G map.  (Reconfigured with CONFIG_RESOURCES_64BIT=y while having 
CONFIG_HIGHMEM4G=y, like in Thomas M's .config.)

So the only thing I can confirm is that the patch builds and runs fine 
on x86-64.
-- 
Stefan Richter
-=====-==--- --== =-===
http://arcgraph.de/sr/

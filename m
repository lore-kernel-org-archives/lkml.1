Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbXLWQLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbXLWQLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 11:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXLWQL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 11:11:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXLWQL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 11:11:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Sun, 23 Dec 2007 17:30:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk>
In-Reply-To: <200712231419.40207.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712231730.34935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Carlos Corbacho wrote:
> Fix suspend-to-RAM on nForce 4 (CK804) boards by increasing
> PCIBIOS_MIN_IO.
> 
> Fixes kernel bugzilla #9528
> 
> Problem:
> 
> Linus' patch (52ade9b3b97fd3bea42842a056fe0786c28d0555) to re-order
> suspend (and fix fall out from Rafael's earlier suspend reordering work)
> broke suspend-to-RAM on nForce 4 (CK804) boards.
> 
> Why:
> 
> After debugging _PTS() in the DSDT, it turns out these nVidia boards are
> trying to write to an IO port > 0x1000 (0x142E) during suspend. Before the
> re-ordering, we got away with this.
> 
> After the afore mentioned commit, we started hitting the PCIBIOS_MIN_IO
> limit and suspend then broke on these machines (the machine simply hangs
> when it reaches the 0x142E IO port write during suspend-to-RAM).
> 
> There was some previous work in the PCIBIOS_MIN_IO area over two years ago
> (71db63acff69618b3d9d3114bd061938150e146b) which bumped this to 0x4000,
> but this was reverted (2ba84684e8cf6f980e4e95a2300f53a505eb794e) after
> causing new and entirely different problems on another nForce board.
> 
> 0x1500 has been picked here as a nice, round and more conservative value
> than 0x4000, and which covers 0x142E.

The patch is fine by me, so if anyone has objections, please speak up.

Thanks,
Rafael


> Tested on x86-64.
> 
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Greg KH <gregkh@suse.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Len Brown <lenb@kernel.org>
> ---
> Since it's not entirely clear who is responsible for what in this file,
> and given what it fixes, I'm CC'ing you all in the hope that someone
> will handle this.
> 
>  include/asm-x86/pci.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
> index e883619..03cb123 100644
> --- a/include/asm-x86/pci.h
> +++ b/include/asm-x86/pci.h
> @@ -46,7 +46,7 @@ extern unsigned int pcibios_assign_all_busses(void);
>  #define pcibios_scan_all_fns(a, b)	0
>  
>  extern unsigned long pci_mem_start;
> -#define PCIBIOS_MIN_IO		0x1000
> +#define PCIBIOS_MIN_IO		0x1500
>  #define PCIBIOS_MIN_MEM		(pci_mem_start)
>  
>  #define PCIBIOS_MIN_CARDBUS_IO	0x4000

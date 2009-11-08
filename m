Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZKHO5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZKHO5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZKHO5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:57:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZKHO5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:57:53 -0500
Date: Sun, 8 Nov 2009 15:57:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/2] x86, amd-ucode: Remove needless log messages
Message-ID: <20091108145748.GB12290@elte.hu>
References: <20091029134552.GC30802@alberich.amd.com>
 <20091029134742.GD30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029134742.GD30802@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:

> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/microcode_amd.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index f4c538b..c043534 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -185,9 +181,6 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
>  
>  	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
>  
> -	printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
> -	       size, total_size);
> -

we should remove this one indeed.

> @@ -109,12 +109,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
>  		return 0;
>  	}
>  
> -	if (mc_header->processor_rev_id != equiv_cpu_id) {
> -		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
> -		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
> -		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
> +	if (mc_header->processor_rev_id != equiv_cpu_id)
>  		return 0;
> -	}
>  
>  	/* ucode might be chipset specific -- currently we don't support this */
>  	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {

but why remove this one? Someone tries to load a mismatching microcode 
file, isnt that some sort of bug in user-space? (Which ought to find out 
whether it has anything for the CPU at hand, and only attempt it if it's 
matching - or so.)

maybe it's not a KERN_ERR but KERN_INFO, but still.

	Ingo

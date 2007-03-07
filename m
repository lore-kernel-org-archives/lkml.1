Return-Path: <linux-kernel-owner+w=401wt.eu-S2992703AbXCGWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992703AbXCGWpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992714AbXCGWpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:45:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35944 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992703AbXCGWpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:45:34 -0500
Date: Wed, 7 Mar 2007 23:45:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 12/20] x86_64: 64bit ACPI wakeup trampoline
Message-ID: <20070307224508.GE5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071458.GM23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307071458.GM23412@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> o Moved wakeup_level4_pgt into the wakeup routine so we can
>   run the kernel above 4G.
> 
> o Now we first go to 64bit mode and continue to run from trampoline and
>   then then start accessing kernel symbols and restore processor context.
>   This enables us to resume even in relocatable kernel context when 
>   kernel might not be loaded at physical addr it has been compiled for.
> 
> o Removed the need for modifying any existing kernel page table.
> 
> o Increased the size of the wakeup routine to 8K. This is required as
>   wake page tables are on trampoline itself and they got to be at 4K
>   boundary, hence one page is not sufficient.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>

> +	if ((&wakeup_end - &wakeup_start) > (PAGE_SIZE*2))
>  		printk(KERN_CRIT
> -		       "ACPI: Wakeup code way too big, will crash on attempt to suspend\n");
> +		       "ACPI: Wakeup code way too big, will crash on attempt"
> +		       " to suspend\n");

Hmm, if you split it like
		printk(KERN_CRIT "ACPI: Wakeup code way too big, will crash"
			"on attempt to suspend\n");

...you'll still keep 80-column rule while keeping it readable.

> @@ -159,11 +159,11 @@ wakeup_32:
>  	 */
>  
>  	/* Finally jump in 64bit mode */
> -	ljmp	*(wakeup_long64_vector - __START_KERNEL_map)
> +        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)

spaces vs. tabs problem.

Otherwise looks good. ACK if it was tested.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

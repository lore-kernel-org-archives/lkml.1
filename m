Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbYGQA2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbYGQA2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYGQA2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:28:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbYGQA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:28:22 -0400
Date: Wed, 16 Jul 2008 17:28:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull] PCI pull request for 2.6.27
In-Reply-To: <200807161639.24289.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0807161715250.2835@woody.linux-foundation.org>
References: <200807161639.24289.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Jesse Barnes wrote:
> 
> I'm open to suggestions here about a couple of caveats with this pull:
>   - it's not merged up to master (though the conflicts are fairly trivial,
>     you can check out my linux-next-merge branch to see how I handled them)

Ok, I handled them without checking your branch, just because I actually 
like feeling like I know what I'm doing.

That said, when I inevitably fail, just humor me, and send me a patch to 
fix it up, mentioning how I missed a really "subtle" thing, and the fact 
that it didn't even compile wasn't really my fault.

I'm special. My mom told me so. And I want the re-assurance.

>   - it contains a revert for a patch I thought might be ready but have since
>     chickened out on.  I didn't want to rebase since I'm carrying some
>     changes from the ACPI tree

That's fine. 

But do double-check the end result. There's lots of small details (for 
example, I did try to just undo the damage from the "overlong lines caused 
somebody to violate all the _other_ coding style rules" patch), but this 
code from setup_64.c:

	+#ifdef CONFIG_PCI
	+	if (pci_early_dump_regs)
	+		early_dump_pci_devices();
	+#endif

that your branch had added I put in the new shared 'setup.c', and while I 
think I put it in the right place, somebody needs to double-check it.

Anyway, I've committed what I think is the right resolve, and it's 
compiled etc, but I want to reboot it before I push out (so if there is 
something seriously broken I can just holler for help or perhaps try to 
fixure it out myself before publicising it), so it's not there yet.

			Linus

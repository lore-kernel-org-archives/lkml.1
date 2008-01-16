Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYAPU0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYAPU0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYAPU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:26:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48518 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYAPUZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:25:59 -0500
Date: Wed, 16 Jan 2008 21:24:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080116202444.GD4212@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116185748.GA11244@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> I just want to report that the PAT support in x86/mm causes crashes on 
> two of my test machines. On both boxes the SATA detection does not 
> work when the PAT support is patched into the kernel.
> 
> Symptoms are as follows -- best described by a diff between the two 
> boot.logs:
> 
> # diff boot-failing.log boot-working.log
> 
> -Linux version 2.6.24-rc8-ga9f7faa5 (root@hunter) (gcc version ...
> +Linux version 2.6.24-rc8-g2ea3cf43 (root@hunter) (gcc version ...
> ...
>  early_iounmap(ffffffff82a0b000, 00001000)
> -early_ioremap(000000000000c000, 00001000) => -000002103394304
> -early_iounmap(ffffffff82a0c000, 00001000)

hm, so the early_ioremap() stuff isnt working well enough ...

that's the main effect of the PAT patches at the moment: no kernel code 
will access the low linear mappings (BIOS tables, ACPI data, etc.) 
directly, it's all done via early_ioremap(). But it's apparently buggy 
somewhere ...

	Ingo

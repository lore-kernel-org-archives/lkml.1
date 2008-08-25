Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYHYDEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYHYDEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 23:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYHYDEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 23:04:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39957 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbYHYDEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 23:04:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>, Vivek Goyal <vgoyal@redhat.com>
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
Date: Sun, 24 Aug 2008 19:52:50 -0700
In-Reply-To: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com> (Yinghai
	Lu's message of "Sun, 24 Aug 2008 15:44:57 -0700")
Message-ID: <m14p59ztz1.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> may need user to have new kexec tools that could create e820 table
> from /sys/firmware/memmap instead of /proc/iomem for second kernel

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

/proc/iomem is mostly about io resources which you have just removed.
It is totally the wrong thing to only register RAM resource!

The use by kexec was and is just taking advantage of something that
already existed.

Eric

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Bernhard Walle <bwalle@suse.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -1279,6 +1279,10 @@ void __init e820_reserve_resources(void)
>  
>  	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
>  	for (i = 0; i < e820.nr_map; i++) {
> +		if (e820.map[i].type != E820_RAM) {
> +			res++;
> +			continue;
> +		}
>  		end = e820.map[i].addr + e820.map[i].size - 1;
>  #ifndef CONFIG_RESOURCES_64BIT
>  		if (end > 0x100000000ULL) {

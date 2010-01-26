Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183Ab0AZAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0AZAna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550Ab0AZAn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:43:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38222 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0AZAn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:43:27 -0500
Message-ID: <4B5E3A12.4030506@zytor.com>
Date: Mon, 25 Jan 2010 16:40:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH -v5 0/38] x86: not use  bootmem for x86
References: <1264152287-13866-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1264152287-13866-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 01:24 AM, Yinghai Lu wrote:
> please check the patches regarding with early_res and bootmem
> 
> it will use early_res instead of bootmem with x86 code.
> but still can use CONFIG_NO_BOOMEM to use bootmem or not
> so could make transistion more smoothly
> 
> -v2: allocate vmemmap on one node together, and also seperate early_res
> -v3: make x86 32 bit support early_res to use bootmem too
>      move related early_res to kernel/
>      sparse vmemmap together: address Ingo.
> -v4: some patches could go with tip with acked-by Jesse
>      radix and logical flat etc
> -v5: put back to 2 patches into this patch to make it consistent
>      as linus pointed out that some place should replace size_t
>      with resource_size_t, and acctually that is done already in
>      those patches in pci/linux-next.
> 

I have been looking at this patchset and tried it out; it has a build
failure because of a naming conflict:

/home/hpa/kernel/linux-2.6-tip.range/drivers/pci/hotplug/ibmphp_res.c:43: error:
conflicting types for ‘add_range’
/home/hpa/kernel/linux-2.6-tip.range/include/linux/range.h:9: note:
previous declaration of ‘add_range’ was here

"add_range" is static.

This makes me concerned that the naming is too generic.  In particular,
we tend to prefer naming of the type subsystem_function(), so in this
case range_add() might be a more suitable naming scheme.

I'm going to spend more time on this patchset.

	-hpa

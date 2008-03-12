Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYCLFjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYCLFjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYCLFjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:39:11 -0400
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:42733
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbYCLFjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:39:11 -0400
Message-ID: <47D76C72.2080603@cosmosbay.com>
Date: Wed, 12 Mar 2008 06:38:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of
 memory
References: <20080312353.598285931@firstfloor.org> <20080312025330.AC1961B41D1@basil.firstfloor.org>
In-Reply-To: <20080312025330.AC1961B41D1@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> Intel recommends to not use large pages for the first 1MB 
> of the physical memory because there are fixed size MTRRs there
> which cause splitups in the TLBs.
> 
> On AMD doing so is also a good idea.
> 
> The implementation is a little different between 32bit and 64bit.
> On 32bit I just taught the initial page table set up about this
> because it was very simple to do. This also has the advantage
> that the risk of a prefetch ever seeing the page even
> if it only exists for a short time is minimized.
> 
> On 64bit that is not quite possible, so use set_memory_4k() a little
> later (in check_bugs) instead.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/bugs_64.c |   12 ++++++++++++
>  arch/x86/mm/init_32.c     |    6 +++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 

Should we then change CONFIG_PHYSICAL_START from 0x100000 to 0x400000 ?

Thank you

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYDHO41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYDHO41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYDHO4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:56:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53838 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756432AbYDHO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:56:06 -0400
Message-ID: <47FB8781.3050809@sgi.com>
Date: Tue, 08 Apr 2008 07:56:01 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408082354.GA13940@elte.hu>
In-Reply-To: <20080408082354.GA13940@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
>> I did see that the malloc space that the inflate code is using is 
>> taken from _after_ the end of the bss. I don't see how this is 
>> protected from being used/overwritten. Changing the stack size changes 
>> the memory layout a bit... maybe you were so unlucky to create a 
>> vmlinux image that was just barely smaller than some threshold and 
>> increasing the stack size made the decompression/relocation area be 
>> located somewhere else?
>>
>> Test patch follows.
> 
> that's a really interesting theory.
> 
> FWIIW, i've been booting allyesconfig bzImages for a long time (with 
> only minimal amount of drivers disabled - mostly old ISA ones that 
> assume the presence of the real hardware), and they boot and work fine 
> on both 32-bit and 64-bit typical whitebox PCs. That means huge bzImages 
> that decompresses into a ~41 MB kernel image. I'd expect that to be a 
> rather severe test of the decompressor.
> 
> 	Ingo

Well admittedly, I did discover this problem way early in booting
up a 4k NR_CPU kernel (obviously ;-).  Once it booted, I haven't
revisited that problem again.  I wonder if it's a pathological case
of a single bitstream that causes expansion instead of compression?
Note I was using the akpm2 config script with NR_CPUS=4096 and
NODES_SHIFT=9 (plus some other tweaks specific to our AMD and Intel
boxes.)

Thanks,
Mike

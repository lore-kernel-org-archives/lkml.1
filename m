Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZFRQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZFRQ3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZFRQ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:29:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZFRQ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:29:26 -0400
Message-ID: <4A3A4790.3090407@zytor.com>
Date: Thu, 18 Jun 2009 06:56:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/16] x86, mce: squash mce_intel.c into therm_throt.c
References: <4A3601BF.2000201@jp.fujitsu.com> <4A3605A2.6000206@jp.fujitsu.com> <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>
In-Reply-To: <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> 2009/6/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>> move intel_init_thermal() into therm_throt.c
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> ---
>>  arch/x86/kernel/cpu/mcheck/Makefile      |    2 +-
>>  arch/x86/kernel/cpu/mcheck/mce_intel.c   |   73 ------------------------------
>>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   66 +++++++++++++++++++++++++++
>>  3 files changed, 67 insertions(+), 74 deletions(-)
>>  delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c
> 
> Why we need this patch? I think the design principle behind MCE is to
> separate vendor/cpu specific code into different files. At least
> #ifdef CONFIG_X86_MCE_INTEL should be used around moved code.
> 

Honestly, such a design principle is pretty broken.  mce_intel.c
contained two completely orthogonal piece of functionality -- CMCI and
thermal -- that really should be in different files (and mce_intel.c
probably should be renamed cmci.c).  Furthermore, using #ifdef for
selecting specific code is considered less clean than using the Makefile
for this purpose.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


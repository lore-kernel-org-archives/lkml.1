Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbXFLGA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbXFLGA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbXFLGAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:00:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:39065 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbXFLGAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:00:50 -0400
Message-ID: <466E3671.2080103@qumranet.com>
Date: Tue, 12 Jun 2007 09:00:17 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612000718.GS3588@stusta.de>
In-Reply-To: <20070612000718.GS3588@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 12 Jun 2007 09:00:18 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>   
>> ...
>> Changes since 2.6.22-rc4-mm1:
>> ...
>>  git-kvm.patch
>> ...
>>  git trees
>> ...
>>     
>
> I'm getting the following compile error with CONFIG_X86_CMPXCHG64=n 
> (with -Werror-implicit-function-declaration - otherwise it would be a 
> link error):
>
> <--  snip  -->
>
> ...
>   CC [M]  drivers/kvm/mmu.o
> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc4-mm2/drivers/kvm/mmu.c: In function ‘set_shadow_pte’:
> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc4-mm2/drivers/kvm/mmu.c:199: error: implicit declaration of function ‘set_64bit’
> make[3]: *** [drivers/kvm/mmu.o] Error 1
>
> <--  snip  -->
>   

I've committed the following, which should disable kvm on i486 and below:

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 2f661e5..33fa28a 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,6 +11,7 @@ if VIRTUALIZATION
 config KVM
        tristate "Kernel-based Virtual Machine (KVM) support"
        depends on X86 && EXPERIMENTAL
+       depends on X86_CMPXCHG64 || 64BIT
        ---help---
          Support hosting fully virtualized guest machines using hardware
          virtualization extensions.  You will need a fairly recent


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


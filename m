Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYFXMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYFXMlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYFXMlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:41:10 -0400
Received: from gw.goop.org ([64.81.55.164]:59960 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYFXMlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:41:09 -0400
Message-ID: <4860EB57.30402@goop.org>
Date: Tue, 24 Jun 2008 08:40:55 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, chrisw@sous-sol.org,
       xen-devel@lists.xensource.com
Subject: Re: [git pull] xen, x86 fixes
References: <20080623194055.GA28384@elte.hu> <20080624073847.GA1897@cs181140183.pp.htv.fi>
In-Reply-To: <20080624073847.GA1897@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Another compile error from the x86 tree:
>
> <--  snip  -->
>
> ...
>   CC      arch/x86/xen/mmu.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/x86/xen/mmu.c: In function ‘xen_pmd_val’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/x86/xen/mmu.c:229: error: ‘pmd_t’ has no member named ‘pmd’
> make[2]: *** [arch/x86/xen/mmu.o] Error 1
>
> <--  snip  -->
>
> The problem seems to be related to CONFIG_X86_PAE=n which results in
> PAGETABLE_LEVELS == 2.
>
> Not visible in -next due to "xen: remove support for non-PAE 32-bit",
> but that is not in 2.6.26.
>   

Thanks Adrian,

Bringing that patch over into .26 would be the easiest fix.  It's 
effectively a bugfix because non-PAE Xen is broken and unusable anyway.

Alternatively, I can easily put a little patch together to use the right 
accessors that will compile in non-PAE.

    J

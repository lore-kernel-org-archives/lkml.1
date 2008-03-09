Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbYCIIjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbYCIIjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 04:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYCIIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 04:39:11 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:59107 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbYCIIjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 04:39:09 -0400
Message-ID: <47D3A22B.10207@free.fr>
Date: Sun, 09 Mar 2008 09:39:07 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6: acpi_os_wait_semaphore tries to
 register non-static key
References: <20080306162606.970aefe1.sfr@canb.auug.org.au>
In-Reply-To: <20080306162606.970aefe1.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06.03.2008 06:26, Stephen Rothwell a écrit :
> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

got this with next-20080306 and next-20080307:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-next-20080306-02654-g4855c7e #25
 [<c012fb3e>] __lock_acquire+0x145/0xaa9
 [<c015566e>] cache_alloc_debugcheck_after+0xdd/0x14e
 [<c01568dd>] kmem_cache_alloc+0x7f/0xca
 [<c01307f5>] lock_acquire+0x4c/0x63
 [<c01291e9>] down_trylock+0x9/0x23
 [<c02915ae>] _spin_lock_irqsave+0x2a/0x39
 [<c01291e9>] down_trylock+0x9/0x23
 [<c01291e9>] down_trylock+0x9/0x23
 [<c01eb93e>] acpi_os_wait_semaphore+0x68/0x13e
 [<c0205c58>] acpi_ut_acquire_mutex+0x5d/0xc1
 [<c01fbea5>] acpi_ns_root_initialize+0x18/0x267
 [<c0382746>] acpi_initialize_subsystem+0x44/0x64
 [<c03829bd>] acpi_early_init+0x54/0xf4
 [<c036f998>] start_kernel+0x24e/0x256
 =======================
Parsing all Control Methods:

~~
laurent

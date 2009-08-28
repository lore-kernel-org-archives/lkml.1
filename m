Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852AbZH1SM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbZH1SM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZH1SM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:12:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52917 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZH1SMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:12:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJi6l0qrR7PD/2dsb2JhbADCFYhAAZAXBYQZ
X-IronPort-AV: E=Sophos;i="4.44,292,1249257600"; 
   d="scan'208";a="377431743"
From: Roland Dreier <rdreier@cisco.com>
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
References: <374672.36063.qm@web45210.mail.sp1.yahoo.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 28 Aug 2009 11:12:26 -0700
In-Reply-To: <374672.36063.qm@web45210.mail.sp1.yahoo.com> (joe Shmoe's
	message of "Fri, 28 Aug 2009 11:08:08 -0700 (PDT)")
Message-ID: <ada8wh3renp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Aug 2009 18:12:27.0424 (UTC) FILETIME=[19B0AA00:01CA280B]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Assuming I have 3GB RAM, why does not kernel create page tables in a way that all of this 3GB physical memory can be addressed . (for x86 arch 32 bit with PAE disabled )
 > 
 > I understand the 3GB/1GB split for user/kernel address space.Isn't  this just a matter of setting up the page table entries in such a way that so all the available RAM upto 3GB can mapped in the kernel page tables. In this way CPU's MMU can take care of mapping any virtual address within first 4GB to physical address using the page table entries regardless of a process is in kernel/user mode. 

On a 32-bit architecture, there is only 4GB of address space available.
If the kernel uses 3GB of address space for a direct mapping of physical
memory, then only 1GB is available for everything else (userspace,
vmalloc, etc).  BTW, this is available by enabling CONFIG_VMSPLIT_1G.

 - R.

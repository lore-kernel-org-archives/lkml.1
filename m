Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbXGBJrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbXGBJrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXGBJrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:47:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:33418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXGBJrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:47:40 -0400
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
References: <20070701203833.GA3498@Ahmed>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Jul 2007 12:43:15 +0200
In-Reply-To: <20070701203833.GA3498@Ahmed>
Message-ID: <p731wfr3x30.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Ahmed S. Darwish" <darwish.07@gmail.com> writes:
> 
> There're some stuff that confused me for a full day about the code (head.S)
> that  accomplishes the above words:
> 
> 	movl $(pg0 - __PAGE_OFFSET), %edi
> 	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx	
> 	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
> 10:
> 	leal $0x007(%edi),%ecx			/* Create PDE entry */
> 
> What does the address of 7 bytes displacement after %edi - the physical address
> of pg0 - represent ?. 

The trick is not to know everything, but to know where to look ...

Page table entries use the first 12 bits for various flags. Take a look
at the Intel or AMD x86 documentation from their websites.

-Andi

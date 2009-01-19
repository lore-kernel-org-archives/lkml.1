Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZASXc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZASXc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZASXct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:32:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZASXcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:32:48 -0500
Date: Tue, 20 Jan 2009 00:32:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       lcm@us.ibm.com, x86@kernel.org
Subject: Re: [PATCH] x86_64: remove kernel_physical_mapping_init() from
	init section
Message-ID: <20090119233227.GA310@elte.hu>
References: <20090119214641.GB7476@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119214641.GB7476@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gary Hade <garyhade@us.ibm.com> wrote:

> kernel_physical_mapping_init() is called during memory hotplug so it 
> does not belong in the init section.
> 
> If the kernel is built with CONFIG_DEBUG_SECTION_MISMATCH=y on the make 
> command line, arch/x86/mm/init_64.c is compiled with the 
> -fno-inline-functions-called-once gcc option defeating inlining of 
> kernel_physical_mapping_init() within init_memory_mapping(). When 
> kernel_physical_mapping_init() is not inlined it is placed in the 
> .init.text section according to the __init in it's current declaration.  
> A later call to kernel_physical_mapping_init() during a memory hotplug 
> operation encounters an int3 trap because the .init.text section memory 
> has been freed.  This patch eliminates the crash caused by the int3 trap 
> by moving the non-inlined kernel_physical_mapping_init() from .init.text 
> to .meminit.text.
> 
> Signed-off-by: Gary Hade <garyhade@us.ibm.com>

applied to tip/x86/urgent, thanks Gary!

	Ingo

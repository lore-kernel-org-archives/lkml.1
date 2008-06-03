Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYFCCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYFCCfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYFCCfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:35:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36514 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYFCCfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:35:41 -0400
Date: Mon, 2 Jun 2008 19:35:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
 Barcelona
Message-ID: <20080602193527.722fbbce@infradead.org>
In-Reply-To: <20080602141928.GH23679@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com>
	<20080528165813.8D8E5814C@erda.amd.com>
	<20080528120253.26fcdb9d@infradead.org>
	<20080602141928.GH23679@erda.amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 16:19:29 +0200
Robert Richter <robert.richter@amd.com> wrote:

> Arjan,
> 
> On 28.05.08 12:02:53, Arjan van de Ven wrote:
> > Comment 1:
> > Can we make the 256/4096 thing conditional on actually having the
> > feature somehow? (while not making the code TOO ugly)
> 
> In the first version I had 2 functions also. The patch have had lots
> of duplicate code or inline functions. Since the conditional check is
> already in raw_pci_* I decided to not implement an additional check
> and use only one function.

ok fair enough.

> 
> > Comment 2: 
> > The cpu_has_XXX is a bit dubious; while it's dependent on your cpu
> > model right now, I'm a bit hesitant to consider a PCI feature
> > something that belongs in the cpu_has_XXX namespace. (Yes I know
> > PCI is moving into the cpu package, but on a logical level it seems
> > just the wrong place).
> > Do we need a platform_has_XXX namespace for things like this?
> 
> An alternative implementation would be here to use a check something
> like pci_probe & PCI_HAS_EXT_CFG. If needed, I will send an updated
> patch.

I kind of prefer this, since logically this is a PCI not a CPU property.
Would you mind doing this ?
(not that your current patch is wrong, it's just nicer to keep CPU
stuff with the CPU and PCI stuff with PCI :)
(This wouldn't need to stop inclusion of your current patch, it can
just be an incremental cleanup)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

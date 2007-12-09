Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXLIVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXLIVeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXLIVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:34:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42201 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXLIVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:34:01 -0500
Date: Sun, 9 Dec 2007 13:33:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-ID: <20071209133311.2db5ce4f@laptopd505.fenrus.org>
In-Reply-To: <587622.50680.qm@web52902.mail.re2.yahoo.com>
References: <1193657365.19938.17.camel@localhost.localdomain>
	<587622.50680.qm@web52902.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 19:41:58 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> Hi,
> 
> I've recently been having trouble loading the hostap_plx 802.11b
> wireless networking driver, and this evening I managed to narrow the
> problem down to these lines of code by copying code from hostap_plx
> into a "test driver" until the test driver also locked the PC up:
> 
>         /* read CIS; it is in even offsets in the beginning of
> attr_mem */ for (i = 0; i < CIS_MAX_LEN; i++)
>                 cis[i] = readb(attr_mem + 2 * i);
> 
> If I comment these lines out then my test driver just complains about
> the garbage CIS information and fails gracefully. Leave these lines
> in and my PC freezes instantly.
> 
> These lines are part of the prism2_plx_check_cis() function, which is
> called when the module first loads. CIX_MAX_LEN is a #define for 256,
> and cis is a u8* pointer previously allocated as:
> 
> cis = kmalloc(CIS_MAX_LEN, GFP_KERNEL);
> 
> attr_mem is one of the function's paramters, and is defined as void
> __iomem *attr_mem.


can you check if the attr_mem is properly ioremap'd ?
(probably with ioremap_nocache)


>         Region 2: Memory at e8002000 (32-bit, non-prefetchable)
> [size=4K] Region 3: I/O ports at 1080 [size=64]
> 
> so there is apparently 4K of I/O memory at 0xe8002000.
> 
> Can anyone help me understand why my PC is locking up when it
> executes this code, please?

I wonder if there's anything else in that area as well..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

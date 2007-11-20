Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbXKTBaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbXKTBaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbXKTB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:26:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759497AbXKTB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:26:42 -0500
Date: Mon, 19 Nov 2007 17:24:18 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "kernel coder" <lhrkernelcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: increased number of cycles
Message-ID: <20071119172418.3894fc25@laptopd505.fenrus.org>
In-Reply-To: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
References: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 21:31:25 -0800
"kernel coder" <lhrkernelcoder@gmail.com> wrote:

> hi,
>         I'm trying to add some code to netif_receive_skb function in
> dev.c file . The cycles consumed by that code was around 16 cycles on
> Dual Core Opetron machine.I'm working on that code for last 6 months
> now and the consumed cycles have always been around 16 cycles .I don't
> touch any other part of kernel .
> 
> But for last 4 days the consumed cycles have suddenly increased to
> around 35 cycles . I'm using RDTSC instruction to profile the
> code.There is no change in code and the kernel version is also the
> same .I am assuming that there  must be something wrong with hardware.

note that profiling a section that takes this short with rdtsc is...
not really working well in practice; you're profiling something that's
smaller (or at least roughly the same size) than the cpu's out of order
speculation window, so your rdtsc greatly impacts what is actually
happening in the code.

as for the change... 16->35 cycles can well be a code or data alignment
change or even a branch misprediction due to some minor code generation
issue.... you're looking at a small microscopic part of the universe
after all, the butterfly in the pacific WILL influence you ;-)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYFDBU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYFDBU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYFDBUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:20:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54450 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYFDBUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:20:18 -0400
Date: Tue, 3 Jun 2008 18:20:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: akataria@vmware.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080603182014.79a38d03@infradead.org>
In-Reply-To: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
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

On Tue, 03 Jun 2008 17:41:09 -0700
Alok Kataria <akataria@vmware.com> wrote:

> On X86 platform we can use the value of cpu_khz computed during tsc
> calibration to calculate the loops_per_jiffy value. Its very
> important to keep the error in lpj values to minimum as any error in
> that may result in kernel panic in check_timer. 
> In virtualization environment on a highly overloaded host, the guest
> delay calibration may sometimes result in errors beyond the ~50% that
> timer_irq_works can handle, resulting in the guest panicking.
\

can you guarantee that the rate tsc ticks at is the same as the current
CPU frequency? Answer: You can't....

sadly we do need to calibrate this...

In addition, clearly you can have different cpus in a system run at a
different rate (both in terms of cpu_khz and, independently, in terms
of tsc rate)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

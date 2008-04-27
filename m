Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbYD0W62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbYD0W62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYD0W6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:58:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYD0W6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:58:20 -0400
Date: Sun, 27 Apr 2008 15:58:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breakage caused by unreviewed patch in x86 tree
Message-ID: <20080427155803.73f0efcf@laptopd505.fenrus.org>
In-Reply-To: <1209329485.3801.46.camel@localhost.localdomain>
References: <1209329485.3801.46.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 16:51:25 -0400
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> This patch:
> 
> commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jan 30 13:33:40 2008 +0100
> 
>     x86: change ioremap() to default to uncached
> 
> As far as I can tell went blindly into the x86 tree without being
> shared on any mailing list at all.  How can something that completely
> alters the semantics of ioremap on x86 platforms go in without any
> review.

it changed from "whatever coinflip you got" to "predictable outcome". 
What you got before was uncached (most of the time), or if the bios was
creative, write combining. Or if the bios was broken in how it set up MTRR's, you could suddenly
get "cached".

When you're mapping device memory, uncached is the safe default. 

With the switch to PAT (and phasing out of MTRR), the kernel needs to pick one of the three
(cached, writecombining, uncached) since you can no longer really depend on MTRRs saving
your bacon there. 
Drivers in general, with VERY few exceptions, want uncached. Any other choice would have been deadly...

I'd like to ask you which one you would pick... you maintain a whole bunch of drivers as scsi maintainer, what would
you have picked?
The answer "whatever the MTRR set up" no longer holds ;(

> 
>  I might add that the intel
> SAPIC functions in roughly the same manner, so this might break more
> than just voyager.

Apics are uncached...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

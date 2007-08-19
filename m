Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbXHSWwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbXHSWwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXHSWwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:52:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:51741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXHSWwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:52:30 -0400
To: Hamish Moffatt <hamish@cloud.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: general protection fault with powernow-k8 frequency scaling on x86-64
References: <20070819034558.GB9431@cloud.net.au>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Aug 2007 01:46:27 +0200
In-Reply-To: <20070819034558.GB9431@cloud.net.au>
Message-ID: <p73d4xj1418.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hamish Moffatt <hamish@cloud.net.au> writes:

> I'm running 2.6.22.1 (Debian's package) although this started happening
> at first with about 2.6.17.

If you can reproduce it you could bisect it. But it's unlikely that it is a 
software problem.

However it might just be that powernow wasn't used in the old kernel
and some change made it work. Also newer kernels tend to change
frequencies more often especially with ondemand; that might have also 
triggered it.


> 
> Here's an example fault; a few more occur a few minutes after that, then
> the whole system locks up soon after. The complete kernel log is below.
> 
> Any ideas?

It sounds like some kind of hardware issue. The Voltage Regulation Module
on the motherboard could have problems with the power supply to the
CPU and that can then cause all kinds of weird effects. On K7 such
problems were fairly common; on K8 less so because powernow 
is more widdespread but can happen occasionally.

It might also be that your hardware degenerated (e.g cheap boards
often have not very long lived components). You could double check
that by running the 2.6.17 kernel again (making sure it does powernow) 

Exchanging the motherboard could potentially safe a lot of trouble.
Or not run powernow anymore.

-Andi

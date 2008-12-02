Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYLBVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYLBVb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLBVbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:31:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:36982 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYLBVbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:31:19 -0500
Subject: Re: [PATCH][for 2.6.28] powerpc: Use physical cpu id when setting
 the processor affinity
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1228246621-25622-1-git-send-email-galak@kernel.crashing.org>
References: <1228246621-25622-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 08:30:23 +1100
Message-Id: <1228253423.7356.195.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 13:37 -0600, Kumar Gala wrote:
> In the CONFIG_SMP case the irq_choose_cpu() code was returning back
> a logical cpu id not the physical id.  We were writing that directly
> into the HW register.
> 
> We need to be calling get_hard_smp_processor_id() so irq_choose_cpu()
> always returns a physical cpu id.

That will probably do for now but if we ever move that routine to
generic code, I'd rather have the caller do the conversion.

Cheers,
Ben.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528Ab0A0Xb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0A0Xb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509Ab0A0Xb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:31:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52302 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab0A0Xb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:31:56 -0500
Date: Wed, 27 Jan 2010 23:29:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: adharmap@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC PATCH 5/5] gic: initialize interrupts as per argument
Message-ID: <20100127232955.GG29665@n2100.arm.linux.org.uk>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org> <1264620749-24527-6-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264620749-24527-6-git-send-email-adharmap@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:32:29AM -0800, adharmap@codeaurora.org wrote:
> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> 
> Initialize interrupts as per an argument passed instead of initializing
> them as active level low triggered interrupts.
> 
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> ---
>  Configuring level triggered interrupts as default may not be correct on
>  some platforms, this changes the default behaviour of the gic_dist_init 
>  function and also adds a flag to indicate whether the default should be level
>  or edge.

Changing the interrupt type for all interrupts is just wrong.  For on-chip
peripherals, you generally want to use level based interrupts as they're
the most efficient and simplest way to signal interrupts.

It should be a per-interrupt thing, and we already have that through
request_irq() etc.  Other platforms manage this just fine without having
to have special configuration like this.

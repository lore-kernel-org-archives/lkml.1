Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYJURff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYJURff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYJURf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:35:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50085 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJURf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:35:27 -0400
To: David John <davidjon@xenontk.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de
Subject: Re: [PATCH v5] HPET: Remove the BKL.
From: Andi Kleen <andi@firstfloor.org>
References: <1224568707-2361-1-git-send-email-davidjon@xenontk.org>
Date: Tue, 21 Oct 2008 19:35:26 +0200
In-Reply-To: <1224568707-2361-1-git-send-email-davidjon@xenontk.org> (David John's message of "Tue, 21 Oct 2008 11:28:27 +0530")
Message-ID: <87abcxetr5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David John <davidjon@xenontk.org> writes:

>  	switch (cmd) {
>  	case HPET_IE_OFF:
> -		if ((devp->hd_flags & HPET_IE) == 0)
> +		spin_lock_irq(&hpet_lock);
> +		if ((devp->hd_flags & HPET_IE) == 0) {
> +			spin_unlock_irq(&hpet_lock);
>  			break;

Reads don't need to be locked here, so you could just move the spin_lock_irq
down a bit and avoid the redundant unlock_irq. Same below.

> +		}

-Andi

-- 
ak@linux.intel.com

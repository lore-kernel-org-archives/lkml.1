Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446Ab0ABTLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0ABTLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027Ab0ABTLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:11:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0ABTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:11:48 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: users of mod_timer_msec()
From: Andi Kleen <andi@firstfloor.org>
References: <20100102104853.28505e39@infradead.org>
	<20100102105012.40d678f2@infradead.org>
Date: Sat, 02 Jan 2010 20:11:45 +0100
In-Reply-To: <20100102105012.40d678f2@infradead.org> (Arjan van de Ven's message of "Sat, 2 Jan 2010 10:50:12 -0800")
Message-ID: <877hs0724u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

>  	emp->activity++;
>  	if (!timer_pending(&emp->timer))
> -		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
> +		mod_timer_msec(&emp->timer, 10);

... but your original patch does

+int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms)
+{
+       return mod_timer(timer, msecs_to_jiffies(delay_ms));


That doesn't look equivalent.

mod_timer_msec should mod_timer_msec_plus_jiffies? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

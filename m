Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYBLMwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYBLMwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYBLMwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:52:43 -0500
Received: from smtp.nokia.com ([192.100.105.134]:42542 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYBLMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:52:42 -0500
Message-ID: <47B19628.8090003@movial.fi>
Date: Tue, 12 Feb 2008 14:50:48 +0200
From: Riku Voipio <riku.voipio@movial.fi>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Adrian Bunk <adrian.bunk@movial.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: futex local DoS on most architectures
References: <20080211130700.GF27537@movial.fi> <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2008 12:51:38.0108 (UTC) FILETIME=[01A2E3C0:01C86D76]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> We have to disable the complete PI/robust functionality for those
> archs, which do not implement futex_atomic_cmpxchg_inatomic(). The
> code in question relies on a valid implementation and does not expect
> -ENOSYS, which is returned by the stub implementation in
> asm-generic/futex.h
>
> Pointed out by: Mikael Pettersson, Riku Voipio and Adrian Bunk
>   
Original credits for finding this issue belong to Lennert Buytenhek.
> This patch is intended for easy backporting and needs to be cleaned up
> further for current mainline.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>
Looks good for me and kernel no longer deadlocks with this patch!

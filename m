Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYGaRtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYGaRtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYGaRtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:49:01 -0400
Received: from gw.goop.org ([64.81.55.164]:51596 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYGaRtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:49:00 -0400
Message-ID: <4891FB0A.907@goop.org>
Date: Thu, 31 Jul 2008 10:48:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Is there still value in having a special tlb flush IPI	vector?
References: <488E534F.2030204@goop.org>	 <200807291430.08220.nickpiggin@yahoo.com.au>	 <1217325288.7563.2.camel@twins>	 <200807292000.30690.nickpiggin@yahoo.com.au> <1217328351.7563.12.camel@twins>
In-Reply-To: <1217328351.7563.12.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> How about using just arch_send_call_function_single_ipi() to implement
> smp_send_reschedule() ?
>
> The overhead of that is a smp_mb() and a list_empty() check in
> generic_smp_call_function_single_interrupt() if there is indeed no work
> to do.
>   

Is doing a no-op interrupt sufficient on all architectures?  Is there
some change a function call IPI might not go through the normal
reschedule interrupt exit path?

    J


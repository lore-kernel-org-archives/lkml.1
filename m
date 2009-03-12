Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZCLN3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZCLN3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZCLN2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:28:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55708 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZCLN2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:28:52 -0400
Date: Thu, 12 Mar 2009 14:48:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] eliminate spurious pointless WARN_ON()s
Message-ID: <20090312134822.GI11935@one.firstfloor.org>
References: <49B91A7E.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B91A7E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 01:21:50PM +0000, Jan Beulich wrote:
> Namely during early boot, the panic() or BUG() paths may end up in
> smp_call_function_*() with just a single online CPU. In that situation
> the warnings generated are not only meaningless, but also result in
> relevant output being cluttered.

I actually have patches that just fix panic/shutdown to never call
smp_call_function(), but use an own vector. It does all kinds of other things
too that are not appropiate in panic, like allocating memory.

My main motivation was for machine checks which currently always
run into WARN_Ons when they panic with interrupts off, but as you
say there are other cases too like early boot.

Will post them later today or tomorrow.

-Andi

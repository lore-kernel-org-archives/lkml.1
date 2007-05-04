Return-Path: <linux-kernel-owner+w=401wt.eu-S1767662AbXEDDnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767662AbXEDDnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767660AbXEDDnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:43:24 -0400
Received: from mta16.adelphia.net ([68.168.78.211]:35225 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767652AbXEDDnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:43:23 -0400
Message-ID: <463AABD7.7090903@acm.org>
Date: Thu, 03 May 2007 22:43:19 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: Serial 8250: clear the lsr_break_flag at open
References: <20070430220858.GA28890@localdomain> <20070501092933.GB18233@flint.arm.linux.org.uk> <46373F42.4080305@acm.org> <20070503120815.GA21024@flint.arm.linux.org.uk>
In-Reply-To: <20070503120815.GA21024@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
>
> The backup code is something I never properly reviewed, so no comments
> there.  The tx_empty code I assumed would be a relatively rare event,
> except when closing the port (at which point you don't particularly care
> about errors anyway, not even the break flag since chances are you'll
> miss the following character.)
>   
That "if" statement in the backup code does look a little dodgy, more
than is perhaps required.  I think it's correct, but I need to add
a lock there in my patch to protect the LSR check.
> Given that people might want to poll it for various reasons, I guess
> saving the status away should be done.  However, there's a slight issue
> with working out which character the error is associated with.  Careful
> locking may be the answer to that though.
>   
I think as long as you hold the port lock while you grab the LSR and
set the saved flags it will work.
> As for start_tx, yes, though slightly harder to check.  Maybe the code
> should be modified to reduce the number of potential LSR reads by reading
> the IIR first, and only if that shows no interrupt pending should the LSR
> be read (and the error flags remembered.)
>   
The version of start_tx in 2.6.21 does check IIR first, and it only
checks the LSR if UART_BUG_TXEN is set, so I assume that's not
a big deal.

I'll sleep on it tonight, look it over tomorrow morning, and resend the
patch.

Thanks,

-corey

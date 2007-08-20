Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbXHTDsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbXHTDsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbXHTDr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:47:59 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:49045 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbXHTDr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:47:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Sun, 19 Aug 2007 21:47:47 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru>
In-Reply-To: <200708181107.56087.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200708192147.47433.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2007 01:07:55 am Andrey Borzenkov wrote:
> This is related to thread "2.6.22-rc: regression: no irda0 interface (2.6.21 
> was OK), smsc does not find chip" but it is already way too overloaded.
> 
> In 2.6.23 smsc-ircc2 fails to initialize IrDA controller. Apparently because 
> it by default is using the same IO port as ttyS3 and this is now claimed by 
> 8250.

8250 should have claimed ttyS3 in 2.6.21 and earlier.  So from
the 8250 point of view, 2.6.21 and 2.6.23 should behave the same.

>From the smsc-ircc2 point of view, 2.6.21 and 2.6.23 should work
the same except for the additional quirk_smc_enable().  If
2.6.23 is worse than 2.6.21, please try removing the body of
quirk_smc_enable() and see whether that makes 2.6.23 as good
as 2.6.21.

For smsc-ircc2, 2.6.23 is definitely a regression from 2.6.22,
because 8250 stayed out of the way in 2.6.22.  But we had to
revert 8250 back to the 2.6.21 behavior because the change
swapped ttyS0 and ttyS1 on some machines, so we just have to
live with that 8250/smsc-ircc2 conflict for the time being.

Bjorn

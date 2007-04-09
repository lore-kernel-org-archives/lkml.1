Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbXDIIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbXDIIo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXDIIo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:44:59 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4587 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbXDIIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:44:58 -0400
Date: Mon, 9 Apr 2007 09:44:48 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070409084447.GB28366@flint.arm.linux.org.uk>
Mail-Followup-To: Roland Dreier <rdreier@cisco.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>
References: <20070330110022.GA21653@flint.arm.linux.org.uk> <20070330110800.GB21653@flint.arm.linux.org.uk> <20070408101826.GA5431@flint.arm.linux.org.uk> <20070408210917.6e306851@the-village.bc.nu> <20070409081824.GA28366@flint.arm.linux.org.uk> <adahcrq550y.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahcrq550y.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 01:24:45AM -0700, Roland Dreier wrote:
>  > Lets say that we want to do MW DMA mode 2.  This has the minimum timing
>  > of 70ns active, 25ns recovery, 120ns cycle time.
>  > 
>  > When you quantise those figures using a clock period of 62.5ns (16MHz)
>  > you end up with: 2 clocks active (2*62.5 > 70), 1 clock recovery
>  > (1*62.5 > 25) and 2 clocks cycle (2*62.5 > 120).
>  > 
>  > Last time I checked, active + recovery must always be equal to the cycle
>  > time, and unless my math is failing me, 2 + 1 does not equal 2.
> 
> Do you mean active + recovery must be less than or equal to the cycle
> time?  Because 70ns + 25ns does not equal 120ns either...

Now that I've had some breakfast, yes.

In any case, active + recovery must never be greater than the cycle time.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

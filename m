Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXLFFNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXLFFNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXLFFMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:12:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45922
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXLFFMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:12:51 -0500
Date: Wed, 05 Dec 2007 21:12:51 -0800 (PST)
Message-Id: <20071205.211251.58003209.davem@davemloft.net>
To: macro@linux-mips.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] esp_scsi: Fix reset cleanup spinlock recursion
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64N.0712051529470.5943@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0712051529470.5943@blysk.ds.pg.gda.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maciej W. Rozycki" <macro@linux-mips.org>
Date: Wed, 5 Dec 2007 16:10:54 +0000 (GMT)

>  The esp_reset_cleanup() function is called with the host lock held and 
> invokes starget_for_each_device() which wants to take it too.  Here is a 
> fix along the lines of shost_for_each_device()/__shost_for_each_device() 
> adding a __starget_for_each_device() counterpart which assumes the lock 
> has already been taken.
> 
>  Eventually, I think the driver should get modified so that more work is 
> done as a softirq rather than in the interrupt context, but for now it 
> fixes a bug that causes the spinlock debugger to fire.
> 
>  While at it, it fixes a small number of cosmetic problems with 
> starget_for_each_device() too.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

Acked-by: David S. Miller <davem@davemloft.net>

Thanks for finding and fixing this bug.


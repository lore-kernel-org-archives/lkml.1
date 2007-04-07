Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbXDGAgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbXDGAgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbXDGAgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:36:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933601AbXDGAgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:36:01 -0400
Date: Fri, 06 Apr 2007 17:36:00 -0700 (PDT)
Message-Id: <20070406.173600.38712619.davem@davemloft.net>
To: mchan@broadcom.com
Cc: nacc@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: tg3: unable to handle null pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175900233.7911.87.camel@dell>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	<20070406214014.GF3346@us.ibm.com>
	<1175900233.7911.87.camel@dell>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Fri, 06 Apr 2007 15:57:13 -0700

> On Fri, 2007-04-06 at 14:40 -0700, Nishanth Aravamudan wrote:
> 
> > 2.6.21-rc5 is ok. 2.6.21-rc6 results in
> > 
> > [   14.241665] Unable to handle kernel NULL pointer dereference (address 0000000000000000)
> 
> Sorry, I think this should fix it:
> 
> [TG3]: Fix crash during tg3_init_one().
> 
> The driver will crash when the chip has been initialized by EFI before
> tg3_init_one().  In this case, the driver will call tg3_chip_reset()
> before allocating consistent memory.
> 
> The bug is fixed by checking for tp->hw_status before accessing it
> during tg3_chip_reset().
> 
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Applied, thanks Michael.

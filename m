Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXDGBz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXDGBz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 21:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXDGBz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 21:55:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44634 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932AbXDGBzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 21:55:55 -0400
Date: Fri, 6 Apr 2007 18:53:01 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mchan@broadcom.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: tg3: unable to handle null pointer dereference
Message-ID: <20070407015301.GA9537@us.ibm.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070406214014.GF3346@us.ibm.com> <1175900233.7911.87.camel@dell> <20070406.173600.38712619.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406.173600.38712619.davem@davemloft.net>
X-Operating-System: Linux 2.6.21-rc5-g59117d3f (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.04.2007 [17:36:00 -0700], David Miller wrote:
> From: "Michael Chan" <mchan@broadcom.com>
> Date: Fri, 06 Apr 2007 15:57:13 -0700
> 
> > On Fri, 2007-04-06 at 14:40 -0700, Nishanth Aravamudan wrote:
> > 
> > > 2.6.21-rc5 is ok. 2.6.21-rc6 results in
> > > 
> > > [   14.241665] Unable to handle kernel NULL pointer dereference (address 0000000000000000)
> > 
> > Sorry, I think this should fix it:
> > 
> > [TG3]: Fix crash during tg3_init_one().
> > 
> > The driver will crash when the chip has been initialized by EFI before
> > tg3_init_one().  In this case, the driver will call tg3_chip_reset()
> > before allocating consistent memory.
> > 
> > The bug is fixed by checking for tp->hw_status before accessing it
> > during tg3_chip_reset().
> > 
> > Signed-off-by: Michael Chan <mchan@broadcom.com>
> 
> Applied, thanks Michael.

FWIW, tested, no panic.

Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

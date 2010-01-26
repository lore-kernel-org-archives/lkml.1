Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010Ab0AZPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0AZPGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560Ab0AZPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:06:17 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:37418 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753536Ab0AZPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:06:17 -0500
Date: Tue, 26 Jan 2010 10:06:09 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: James Kosin <james.kosin.04@cnu.edu>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/24] drivers/block/floppy.c: Add function
 is_ready_state
Message-ID: <20100126150609.GA24349@emergent.ellipticsemi.com>
Mail-Followup-To: James Kosin <james.kosin.04@cnu.edu>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
References: <e5jMK-25X-3@gated-at.bofh.it>
 <e5jMM-25X-51@gated-at.bofh.it>
 <4B5B32AF.1010509@cox.net>
 <1264279618.30778.34.camel@Joe-Laptop.home>
 <4B5E44DD.9090305@cnu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E44DD.9090305@cnu.edu>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:26 Mon 25 Jan     , James Kosin wrote:
> On 1/23/2010 3:46 PM, Joe Perches wrote:
> > On Sat, 2010-01-23 at 12:32 -0500, James Kosin wrote:
> >    
> >> On 1/22/2010 12:00 AM, Joe Perches wrote:
> >>      
> >>> +static bool is_ready_state(int status)
> >>> +{
> >>> +	int state = status&   (STATUS_READY | STATUS_DIR | STATUS_DMA);
> >>> +	return state == STATUS_READY;
> >>> +}
> >>> +
> >>>        
> >> This should probably be simplified to:
> >>
> >> static bool is_ready_state(int status)
> >> {
> >> 	return ((state&  STATUS_READY) == STATUS_READY);
> >> }
> >>      
> > Certainly not.
> > That wouldn't be the same code.
> >
> > include/linux/fdreg.h:#define STATUS_DMA	0x20		/* 0- DMA mode */
> > include/linux/fdreg.h:#define STATUS_DIR	0x40		/* 0- cpu->fdc */
> > include/linux/fdreg.h:#define STATUS_READY	0x80		/* Data reg ready */
> >    
> Read the code....
> 
> It simplifies what is already there.  The two other status flags make no 
> difference in the test for equality with STATUS_READY.

Sure they do: the old code tests that the STATUS_READY is set and
both STATUS_DMA and STATUS_DIR bits are clear.  So, for example, if
STATUS_READY and STATUS_DMA are both set, then the old test will return
false.

Your "simplification" has removed the check for those clear bits, and
will return true even if all three bits are set.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

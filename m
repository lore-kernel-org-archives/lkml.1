Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496Ab0AKNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0AKNGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481Ab0AKNGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:06:34 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60577 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0AKNGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:06:33 -0500
Date: Tue, 12 Jan 2010 00:06:31 +1100
From: Simon Horman <horms@verge.net.au>
To: Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Huewe <PeterHuewe@gmx.de>
Subject: Re: [patch 6/6] otus: zfRateCtrlRateDiff(): remove duplicate
 comparison
Message-ID: <20100111130631.GB5198@verge.net.au>
References: <20100108075748.059645106@vergenet.net>
 <20100108075921.504899210@vergenet.net>
 <20100109084438.GD7840@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100109084438.GD7840@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 11:44:38AM +0300, Dan Carpenter wrote:
> On Fri, Jan 08, 2010 at 06:57:54PM +1100, horms@vergenet.net wrote:
> > I think this is correct.
> > 
> > $ gcc (Debian 4.4.2-8) 4.4.2
> > Copyright (C) 2009 Free Software Foundation, Inc.
> > This is free software; see the source for copying conditions.  There is NO
> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > 
> > $ make
> > ...
> > drivers/staging/otus/80211core/ratectrl.c: In function
> > 'zfRateCtrlRateDiff':
> > drivers/staging/otus/80211core/ratectrl.c:433: warning: suggest parentheses
> > around comparison in operand of '=='
> > ...
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > Index: linux-2.6/drivers/staging/otus/80211core/ratectrl.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/staging/otus/80211core/ratectrl.c	2010-01-08 17:13:44.000000000 +1100
> > +++ linux-2.6/drivers/staging/otus/80211core/ratectrl.c	2010-01-08 17:14:02.000000000 +1100
> > @@ -430,7 +430,7 @@ u8_t zfRateCtrlRateDiff(struct zsRcCell*
> >              {
> >                  return ((rcCell->currentRateIndex - i)+1)>>1;
> >              }
> > -            else if (i == rcCell->currentRateIndex == 0)
> > +            else if (i == rcCell->currentRateIndex)
> 
> You realize you have reversed the meaning of the test?  The original 
> was the same as if (i != rcCell->currentRateIndex).
> 
> Your patch is possibly correct, but it's hard to know.  I would
> leave this for now until someone grovels through the code to find
> out for sure if it should be == or !=.  If we silence the warning,
> no one will ever look at this code again.

Good point, I withdraw this patch.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYLGUUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYLGUUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYLGUUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:20:21 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54362 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYLGUUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:20:21 -0500
Date: Sun, 7 Dec 2008 21:22:49 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: linux-next: Tree for December 3 (MFD)
Message-ID: <20081207202248.GA3928@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au> <49373373.2080901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49373373.2080901@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 05:33:39PM -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20081202:
> > 
> > Today's tree fails the powerpc allyesconfig build.
> 
> 
> drivers/mfd/twl4030-core.c uses clk_get_rate() and clk_put(),
> but they don't seem to exist for x86, so I'm getting build errors:
> 
> twl4030-core.c:(.text+0x16a797): undefined reference to `clk_get_rate'
> twl4030-core.c:(.text+0x16a7a6): undefined reference to `clk_put'
On my build system, I can't trigger this build error until I remove the osc =
ERR_PTR(-EIO); line. I assume gcc is smart enough to compile the rest of the
code out when osc is set to ERR_PTR().
Anyway, the fix is now part of my for-next branch.

Cheers,
Samuel.

 
> 
> ~Randy

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

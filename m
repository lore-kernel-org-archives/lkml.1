Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbXFUR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbXFUR7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXFUR7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:59:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60510 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbXFUR7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:59:04 -0400
Subject: Re: [PATCH for 2.6.22] [6/10] x86: Only make Macintosh drivers
	default on Macs
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Olaf Hering <olaf@aepfle.de>
Cc: Andi Kleen <ak@suse.de>, torvalds@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070621173628.GA21243@aepfle.de>
References: <200706201223.443613000@suse.de>
	 <20070620102334.DD01814AD0@wotan.suse.de>
	 <20070621173628.GA21243@aepfle.de>
Content-Type: text/plain
Organization: IBM
Date: Thu, 21 Jun 2007 12:58:45 -0500
Message-Id: <1182448725.25426.19.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 19:36 +0200, Olaf Hering wrote:
> On Wed, Jun 20, Andi Kleen wrote:
> 
> > 
> > It's already annoying that they appear on x86 now -- that's for the 3button
> > emulation needed on x86 macs -- but at least don't make them default.
> > 
> > Signed-off-by: Andi Kleen <ak@suse.de>
> > 
> > ---
> >  drivers/macintosh/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux/drivers/macintosh/Kconfig
> > ===================================================================
> > --- linux.orig/drivers/macintosh/Kconfig
> > +++ linux/drivers/macintosh/Kconfig
> > @@ -2,7 +2,7 @@
> >  menuconfig MACINTOSH_DRIVERS
> >  	bool "Macintosh device drivers"
> >  	depends on PPC || MAC || X86
> > -	default y
> > +	default y if MAC
> 
> This looks incorrect because my macdrivers were almost gone now when
> updating from 2.6.21 to 2.6.22. 
> A better one may be something like this, to not lose everything on a G5:
> 
>         depends on PPC_PMAC || MAC || X86
>         default y if (PPC_PMAC || MAC)
> 

I'll second that.  The obvious gotcha is that on a G5, the windfarm
drivers don't get automatically selected, thus the fans run at full
speed, and my office becomes a windtunnel. :-) 

-Will


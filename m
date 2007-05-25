Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbXEYQmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbXEYQmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXEYQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:42:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbXEYQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:42:03 -0400
Date: Fri, 25 May 2007 09:41:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] potential parse error in ifdef
Message-Id: <20070525094136.00be86ae.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705251349330.8531@twin.jikos.cz>
References: <87abvtfi9w.fsf@wanadoo.fr>
	<Pine.LNX.4.64.0705251349330.8531@twin.jikos.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 13:50:37 +0200 (CEST) Jiri Kosina <jikos@jikos.cz> wrote:

> On Fri, 25 May 2007, Yoann Padioleau wrote:
> 
> > I have made a tool to parse the kernel that does not pre-process the
> > source. That means that my parser tries to parse all the code, including
> > code in the #else branch or code that is not often compiled because
> > the driver is not very used (or not used at all). So, my parser
> > sometimes reports parse error not originally detected by gcc. 
> > Here is my (first) patch.
> >  drivers/char/watchdog/ixp2000_wdt.c |    2 +-
> >  drivers/mtd/devices/pmc551.c        |    2 +-
> >  drivers/mtd/nand/autcpu12.c         |    2 +-
> >  drivers/mtd/nand/ppchameleonevb.c   |    2 +-
> >  drivers/net/amd8111e.c              |    2 +-
> >  drivers/net/skfp/smt.c              |    2 +-
> >  drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
> >  sound/arm/sa11xx-uda1341.c          |    2 +-
> >  8 files changed, 8 insertions(+), 8 deletions(-)
> 
> As these are totally independent fixes across various subsystems, you 
> should probably split the patch into per-subsystem patches and submit them 
> separately.

That's normally true, yes.  But for a bunch of obviously-better one-line
fixes in code which nobody has even compiled in ages, I think we can bend
the rules a bit and just slam it in.


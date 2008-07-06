Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYGFEOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYGFEOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 00:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYGFEOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 00:14:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53341
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbYGFEOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 00:14:00 -0400
Date: Sat, 05 Jul 2008 21:14:00 -0700 (PDT)
Message-Id: <20080705.211400.95116379.davem@davemloft.net>
To: jeff@garzik.org
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [NET-NEXT PATCH 08/18] igb: Introduce multiple TX queues with
 infrastructure
From: David Miller <davem@davemloft.net>
In-Reply-To: <486E1ADE.50706@garzik.org>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
	<20080627180044.22428.21729.stgit@localhost.localdomain>
	<486E1ADE.50706@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 04 Jul 2008 08:43:10 -0400

> Jeff Kirsher wrote:
> > From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> > 
> > This code adds multiple Tx queue infrastructure much like we
> > previously did in ixgbe. The MSI-X vector mapping is the bulk of
> > the change.
> > 
> > IAM can now be safely enabled and we've verified that it does
> > work correctly. We can also eliminate the tx ring lock.
> > 
> > Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> > Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
> > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> > ---
> > 
> >  drivers/net/igb/igb.h      |    6 +-
> >  drivers/net/igb/igb_main.c |  160 ++++++++++++++++++++++++++++++--------------
> >  2 files changed, 113 insertions(+), 53 deletions(-)
> 
> presumably this should wait for david to finish his multi-TX stuff?

Adding infrastructure now is a good thing.  I did something similar
for NIU, and the Broadcom folks have done similar for bnx2*.

That's why the NIU multiqueue TX patch in my series was only 10 lines
of changes, all the infrastructure and init was in the driver already :-)

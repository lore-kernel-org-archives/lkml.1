Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYLAULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYLAULW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYLAULN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:11:13 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36444 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYLAULM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:11:12 -0500
Date: Mon, 1 Dec 2008 21:11:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Olof Johansson <olof@lixom.net>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
In-Reply-To: <20081201180812.GA21646@lixom.net>
Message-ID: <Pine.LNX.4.64.0812012109480.1541@ask.diku.dk>
References: <Pine.LNX.4.64.0811271319070.15160@pc-004.diku.dk>
 <20081201174327.GA21274@lixom.net> <Pine.LNX.4.64.0812011838440.11341@pc-004.diku.dk>
 <20081201180812.GA21646@lixom.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Olof Johansson wrote:

> On Mon, Dec 01, 2008 at 06:39:01PM +0100, Julia Lawall wrote:
> > On Mon, 1 Dec 2008, Olof Johansson wrote:
> > 
> > > On Thu, Nov 27, 2008 at 01:19:49PM +0100, Julia Lawall wrote:
> > > > From: Julia Lawall <julia@diku.dk>
> > > > 
> > > > pci_get_device increments a reference count that should be decremented
> > > > using pci_dev_put.  I have thus added an extra label in the error handling
> > > > code to do this.  I don't know, however, whether there should be a
> > > > pci_dev_put before the return 0 as well.
> > > > 
> > > [...]
> > > 
> > > > Signed-off-by: Julia Lawall <julia@diku.dk>
> > > 
> > > Acked-by: Olof Johansson <olof@lixom.net>
> > 
> > Do you know the answer about the return 0?
> 
> Teaches me to read the patch description twice.
> 
> Either there or in pasemi_nand_remove(), doesn't matter much to me. Doing
> it before the return 0 is the smaller change.

Actually, could pci_dev_put(pdev) be placed right after:

lpcctl = pci_resource_start(pdev, 0);

Then there would only be one, and the rest of the code could go back to 
its original form.

julia

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYBSWt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYBSWt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760800AbYBSWtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:49:46 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38171 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760473AbYBSWtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:49:45 -0500
Date: Wed, 20 Feb 2008 00:49:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@gmail.com>, ambx1@neo.rr.com
Cc: linux-kernel@vger.kernel.org
Subject: pnp_bus_resume(): inconsequent NULL checking
Message-ID: <20080219224908.GM31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking 
introduced by commit 5d38998ed15b31f524bde9a193d60150af30d916:

<--  snip  -->

...
static int pnp_bus_resume(struct device *dev)
{
...
        if (pnp_dev->protocol && pnp_dev->protocol->resume)
                pnp_dev->protocol->resume(pnp_dev);

        if (pnp_can_write(pnp_dev)) {
...

<--  snip  -->

pnp_can_write(pnp_dev) dereferences pnp_dev->protocol.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


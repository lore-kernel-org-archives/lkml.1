Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130Ab0ADHYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0ADHYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 02:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0ADHYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 02:24:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:37135 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab0ADHYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 02:24:43 -0500
Date: Mon, 4 Jan 2010 16:24:23 +0900
To: sfr@canb.auug.org.au
Cc: airlied@linux.ie, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: Re: linux-next: agp tree build failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100101110327.425e0a0d.sfr@canb.auug.org.au>
References: <20100101110327.425e0a0d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100104162405A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 04 Jan 2010 16:24:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jan 2010 11:03:27 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/char/agp/amd64-agp.c: In function '__exittest':
> drivers/char/agp/amd64-agp.c:782: error: 'agp_amd64_cleanup' undeclared (first use in this function)
> 
> Caused by commit f405d2c02395a74d3883bd03ded36457aa3697ad ("x86/agp: Fix
> agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled") from the
> origin tree interacting with commit
> e85c5c6542528aba88a5d811652cf0e2d44f7f07 ("drivers/char/agp/amd64-agp.c:
> squish warning") from the agp tree.

The former patch was already merged to fix:

http://marc.info/?l=linux-kernel&m=126192729110083&w=2

I think that the latter commit in agp tree isn't necessary since with
the former patch, agp_amd64_cleanup is necessary even with
CONFIG_GART_IOMMU enabled.

But the former patch added another bug. I've just posted a fix for
it. Sorry about that.

http://marc.info/?l=linux-kernel&m=126258945607963&w=2

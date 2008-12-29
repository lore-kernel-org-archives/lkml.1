Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbYL2Vv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbYL2Vv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYL2VvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:51:13 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59334 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196AbYL2VvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:51:11 -0500
Subject: Re: linux-next: Tree for December 29 (cxgb3i)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kxie@chelsio.com
In-Reply-To: <20081229123517.23fd6169.randy.dunlap@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229123517.23fd6169.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 15:51:07 -0600
Message-Id: <1230587467.3302.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 12:35 -0800, Randy Dunlap wrote:
> On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20081219:
> > 
> > Undropped tree:
> > 	scci
> > 	mtd
> > 
> > Dropped trees (temporarily):
> > 	nfs (akpm request due to 2.6.30 features)
> > 	kvm (build problem)
> > 	rr (build poblem)
> > 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> > 	cpu_alloc (build problem)
> > 	audit (difficult conflicts)
> > 
> > Linus' tree had three build failures requiring patches and one requiring
> > a revert.
> 
> 
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:499: error: 'struct sk_buff' has no member named 'sp'
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:512: error: 'struct sk_buff' has no member named 'sp'
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:532: error: 'struct sk_buff' has no member named 'sp'
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:533: error: 'struct sk_buff' has no member named 'sp'

In the config 20 questions, my guess for this is CONFIG_XFRM=n

I'm not at all sure why this driver is playing with the secure path ...
I suspect the use needs to be enclosed in #ifdef CONFIG_XFRM pairs, but
I'd like the maintainers to verify.

James



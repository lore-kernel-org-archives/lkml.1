Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZHLXRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZHLXRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZHLXRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:17:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZHLXRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:17:31 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 13 Aug 2009 09:17:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19075.19867.522323.983427@notabene.brown>
Cc: sage@newdream.net, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
In-Reply-To: message from Andrew Morton on Tuesday August 11
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
	<8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
	<20090811145258.6cd823d6.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 11, akpm@linux-foundation.org wrote:
> On Tue, 4 Aug 2009 08:03:52 +1000 (EST)
> "NeilBrown" <neilb@suse.de> wrote:
> 
> > On Tue, August 4, 2009 6:54 am, Sage Weil wrote:
> > > The kzalloc mempool does not re-zero items that have been used and then
> > > returned to the pool.  Manually zero the allocated multipath_bh instead.
> > >
> > > CC: linux-raid@vger.kernel.org
> > > CC: Neil Brown <neilb@suse.de>
> > > CC: <stable@kernel.org>
> 
> Sage, why did you cc stable@kernel.org?  The patch fixes some bug? 
> What is it?  Why is the fix sufficiently important to warrant
> backporting?
> 
> > Acked-by: NeilBrown <neilb@suse.de>
> > 
> 
> Thanks, I'll merge it once the above is understood.
> 
> > 
> > In fact, you don't even need the memset.  After allocation
> > no assumptions are made about the content of the structure.
> > Every field is immediately initialised except retry_list, which
> > is never accessed until after the object is placed on a list.h list.
> > 
> > So this code never needed kzalloc_pool.
> 
> Well, that's a bit of a functional change so let us (ie: you ;)) do
> that separately?

Yes, I'll keep an eye out for your change to be merged, then I'll
apply mine.

NeilBrown

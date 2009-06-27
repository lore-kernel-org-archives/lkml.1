Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZF0HfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZF0HfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZF0HfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 03:35:05 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:38286 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZF0HfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 03:35:04 -0400
Subject: Re: [PATCH 07/10] decnet: Use rcu_barrier() on module unload.
From: Jesper Dangaard Brouer <hawk@comx.dk>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, David Miller <davem@davemloft.net>,
       paulmck@linux.vnet.ibm.com, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       yoshfuji@linux-ipv6.org, linux-nfs@vger.kernel.org,
       linux-ext4@vger.kernel.org, catalin.marinas@gmail.com
In-Reply-To: <alpine.DEB.2.01.0906262010091.6439@bogon>
References: <1245845367.24921.3.camel@localhost.localdomain>
	 <5A680E0A-EFEB-44EA-9F06-F338E6CBD6D1@googlemail.com>
	 <1245930729.24921.67.camel@localhost.localdomain>
	 <20090625.161046.19938291.davem@davemloft.net>
	 <Pine.LNX.4.64.0906262100210.14848@ask.diku.dk>
	 <alpine.DEB.2.01.0906262010091.6439@bogon>
Content-Type: text/plain
Organization: ComX Networks A/S
Date: Sat, 27 Jun 2009 09:35:04 +0200
Message-Id: <1246088104.29340.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2009 07:35:05.0403 (UTC) FILETIME=[CA0ED8B0:01C9F6F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 20:15 -0700, Christian Kujau wrote:
> On Fri, 26 Jun 2009, Jesper Dangaard Brouer wrote:
> > I'll resubmit the patches to you and netdev, to limit the spam effect...
> 
> Out of curiosity: why was linux-ext4 Cc'ed on these rcu_barrier patches
> (but not other fs-lists but linux-nfs)? I did not see any ../fs/ext4/ 
> changes.

There was a ../fs/ext4/ change in patch [01/10].

Titled: "ext4: Use rcu_barrier() on module unload"

git show --stat d6a4ea73b7e8779607dd48735d9a9c521c890857
commit d6a4ea73b7e8779607dd48735d9a9c521c890857
Author: Jesper Dangaard Brouer <hawk@comx.dk>
Date:   Tue Jun 23 15:40:54 2009 +0200

    ext4: Use rcu_barrier() on module unload.
    
    The ext4 module uses rcu_call() thus it should use rcu_barrier()on
    module unload.
    
    The kmem cache ext4_pspace_cachep is sometimes free'ed using
    call_rcu() callbacks.  Thus, we must wait for completion of call_rcu()
    before doing kmem_cache_destroy().
    
    I have difficult determining if no new call_rcu() callbacks can be envoked.
    Would the maintainer please verify this?
    
    Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

 fs/ext4/mballoc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer


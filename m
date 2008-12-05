Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYLEB0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYLEB0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLEB0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:26:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYLEB0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:26:31 -0500
Date: Fri, 5 Dec 2008 02:37:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081205013739.GZ6703@one.firstfloor.org>
References: <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com> <20081204174838.GS6703@one.firstfloor.org> <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com> <20081204221551.GV6703@one.firstfloor.org> <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com> <20081205004849.GX6703@one.firstfloor.org> <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * barrier support in md-raid1 deviates from the specification at 
> Documentation/block/barrier.txt. The specification says that requests 
> submitted after the barrier request hit the media after the barrier 
> request hits the media. The reality is that the barrier request can be 
> randomly aborted and the requests submitted after it hit the media before 
> the barrier request.

Yes the spec should be probably updated.

But also see Linus' rant from yesterday about code vs documentation.
When in doubt the code wins.
> 
> * the filesystems developed hacks to work around this issue, the hacks 
> involve not submitting more requests after the barrier request, 

I suspect the reason the file systems did it this way is that
it was a much simpler change than to rewrite the transaction
manager for this.

> synchronously waiting for the barrier request and eventually retrying it. 
> These hacks suppress any performance advantage barriers could bring.
> 
> * you submit a patch that makes barriers even more often deviate from the 
> specification and you argue that the patch is correct because filesystems 
> handle this deviation.

Sorry what counts is the code behaviour, not the specification.

-Andi

-- 
ak@linux.intel.com

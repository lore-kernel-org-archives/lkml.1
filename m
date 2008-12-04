Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYLDORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYLDORU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYLDORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:17:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYLDORK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:17:10 -0500
Date: Thu, 4 Dec 2008 09:17:04 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
 barriers.)
In-Reply-To: <20081204142015.GQ6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
 <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
 <20081204142015.GQ6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008, Andi Kleen wrote:

> > the 1st write request ends with success
> > the 2nd write request ends with -EOPNOTSUPP
> > the 3rd write request ends with success
> > 
> > --- when you first see -EOPNOTSUPP, you have already corrupted filesystem 
> > (the 3rd write passed while the filesystem expected that it would be 
> 
> There's no passing of requests during pvmove. It's a really strong
> barrier.

You start pvmove. The filesystem doesn't know about pvmove.

The next time filesystem does somethig, it submits these 3 requests and 
the 2nd fill unexpectedly fail.

So the fact that pvmove drains the request queue won't help you.

> > finished after the 2nd write) and you are in an interrupt context, where 
> > you can't reissue -EOPNOTSUPP request. So what do you want to do?
> 
> The barrier aware file systems I know of just resubmit synchronously when 
> a barrier fails.

... and produce structure corruption for certain period in time, because 
the writes meant to be ordered are submitted unordered.

Mikulas

> -Andi
> 

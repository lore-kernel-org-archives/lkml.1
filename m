Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYACUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYACUNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYACUNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:13:10 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:63751 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYACUNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:13:09 -0500
Date: Thu, 03 Jan 2008 15:13:07 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
In-reply-to: <adafxxeu495.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Message-id: <1199391187.7561.38.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <adak5mqu5i8.fsf@cisco.com>
 <1199385590.7561.11.camel@lap75545.ornl.gov> <adafxxeu495.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 10:56 -0800, Roland Dreier wrote:
> > If we've got time before 2.6.24 final, I'd wait on this a bit.
>  > ib_srp:srp_remove_work() has them reversed as well, and I'm currently
>  > tracking down why it oopses when the srp_remove_host() happens before
>  > the scsi_remove_host(), which is the documented call sequence.
> 
> I think the best thing to do is to merge this (assuming that Linus
> gets to it), since it looks quite safe and definitely fixes a crash.
> Then if we get to the root cause we can change the order of the calls
> if it turns out a different fix is required.

I've made progress on the root cause (posted in another thread), but we
need to fix ib_srp.c:srp_remove_work() as well, as I think it will have
the same issue. It will only be hit if we cannot reconnect to the
target, so it probably doesn't see a lot of use.

I'll send a new patch to you for just the ib_srp.c side.
Dave


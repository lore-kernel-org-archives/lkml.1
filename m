Return-Path: <linux-kernel-owner+w=401wt.eu-S1763520AbXJNUg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763520AbXJNUg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXJNUgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:36:50 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:11040 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbXJNUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:36:49 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Sun, 14 Oct 2007 22:36:10 +0200
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <20071012212223.GD16418@kroah.com> <200710130953.22099.elendil@planet.nl>
In-Reply-To: <200710130953.22099.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710142236.10768.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 13. Oktober 2007 schrieb Frans Pop:
> > > Please consider this patch for 2.6.23.2
> > > http://lkml.org/lkml/2007/10/4/389
> > Is it already in Linus's tree?  If so, do you have a git commit id?  If
> > not, please let us (stable@) know when it is, and what the id is, and
> > then we can add it to our tree.
> 
> Not AFAICT.
> CCing Christian (as patch author) and Ingo (as author of the change that 
> caused the regression) so they can push it through the correct channels.
> 

I dont know how to proceed with this issue. The more I think about it, the
more I am convinced that using sum_exec_runtime together with sampled utime
and stime will never guarantee monotonicity for utime and stime in proc. 
Just imagine an process with 9 ticks for utime and 0 ticks for stime. If
we now sample one tick for stime (but having only a small increase in
sum_exec_runtime) the next utime value will only be 90% of the last value. 
So returning to the 2.6.22 model seems to be the safest solution until 
somebody else comes up with an idea that works proper.

Ingo, any opinion?

Christian

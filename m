Return-Path: <linux-kernel-owner+w=401wt.eu-S934671AbXGQVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671AbXGQVce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXGQVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:32:25 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:28155 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbXGQVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:32:24 -0400
Date: Wed, 18 Jul 2007 00:32:15 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
Message-ID: <20070717213215.GC17168@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <OF2377E85C.B05BDE94-ONC125731A.006E64A7-C125731A.00714F9E@de.ibm.com>
	<ada1wf7vgfb.fsf@cisco.com> <20070717043740.GB8527@mellanox.co.il>
	<adalkdesyrs.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adalkdesyrs.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
> 
>  > Here's some anecdotal evidence :)
>  > http://lists.openfabrics.org/pipermail/general/2007-May/035758.html
> 
> Right, but then we went on to say that we probably want to use
> multiple vectors to separate out multiple HCA ports rather than
> send/sreceive on the same port.  And the current IPoIB implementation
> of having that second CQ seems suboptimal anyway, since it seems to
> leave us susceptible to the interrupt overload that NAPI was supposed
> to solve.

Sure, the ipoib patch is just a proof of concept anyway.
And I'm actually working on merging send/recv CQs now,
to address the livelocks.

> At a higher level, I'm left wondering why nobody talked about multiple
> EQs during the last months of the 2.6.22 process and now all of a
> sudden it becomes urgent in the last few days of the 2.6.23 merge
> window.

I don't see any emergency in merging the IPoIB hack either.

I just hoped that once we merge the core changes people will start
experimenting with multiple vectors. This did not seem to have happened.
Could this be because there's no low level driver support upstream yet?

So I wonder whether merging the mthca patch [that was patch 2 of the series]
in 2.6.23 will finally get the
ball rolling, get people to experiment with multiple vectors
in userspace, and that will hopefully teach us something.

> That's not really how I like to merge features....

If you look just at the mthca patch in isolation,
do you still see a problem?

-- 
MST

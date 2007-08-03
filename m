Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXHCEJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXHCEJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXHCEJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:09:06 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:51102 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbXHCEJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ji0aULTEin5ge2MOM23jqLmqxg5sveAW6tD4gfhQlv7oQ+WYuvlilQWIlHFRhOoBg4tCOFxuQtkYSLv+EKnDV71ZWDoIh+riFtnYqMbiyiI+SWIvE/9MOoEnA2r1vwPoNNUHUSzgMRrKMSPQowzkLZZGOS3RdSv8730AyZqFYD4=
Message-ID: <170fa0d20708022109s60ebb85aqe68ec1033634ef27@mail.gmail.com>
Date: Fri, 3 Aug 2007 00:09:02 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage.
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Daniel Phillips" <phillips@phunq.net>
In-Reply-To: <20070731171347.GA14267@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731171347.GA14267@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
>
> I'm pleased to announce first release of the distributed storage
> subsystem, which allows to form a storage on top of remote and local
> nodes, which in turn can be exported to another storage as a node to
> form tree-like storages.

Very interesting work, I read through your blog for the project and it
is amazing how quickly you developed/tested this code.  Thanks for
capturing the evolution of DST like you have.

> Compared to other similar approaches namely iSCSI and NBD,
> there are following advantages:
>     * non-blocking processing without busy loops (compared to both above)
>     * small, plugable architecture
>     * failover recovery (reconnect to remote target)
>     * autoconfiguration (full absence in NBD and/or device mapper on top of it)
>     * no additional allocatins (not including network part) - at least two in
>         device mapper for fast path
>     * very simple - try to compare with iSCSI
>     * works with different network protocols
>     * storage can be formed on top of remote nodes and be exported
>         simultaneously (iSCSI is peer-to-peer only, NBD requires device
>         mapper and is synchronous)

Having the in-kernel export is a great improvement over NBD's
userspace nbd-server (extra copy, etc).

But NBD's synchronous nature is actually an asset when coupled with MD
raid1 as it provides guarantees that the data has _really_ been
mirrored remotely.

> TODO list currently includes following main items:
>     * redundancy algorithm (drop me a request of your own, but it is highly
>         unlikley that Reed-Solomon based will ever be used - it is too slow
>         for distributed RAID, I consider WEAVER codes)

I'd like to better understand where you see DST heading in the area of
redundancy.    Based on your blog entries:
http://tservice.net.ru/~s0mbre/blog/devel/dst/2007_07_24_1.html
http://tservice.net.ru/~s0mbre/blog/devel/dst/2007_07_31_2.html
(and your todo above) implementing a mirroring algorithm appears to be
a near-term goal for you.  Can you comment on how your intended
implementation would compare, in terms of correctness and efficiency,
to say MD (raid1) + NBD?  MD raid1 has a write intent bitmap that is
useful to speed resyncs; what if any mechanisms do you see DST
embracing to provide similar and/or better reconstruction
infrastructure?  Do you intend to embrace any exisiting MD or DM
infrastructure?

BTW, you have definitely published some very compelling work and its
sad that you're predisposed to think DST won't be recieved well if you
pushed for inclusion (for others, as much was said in the 7.31.2007
blog post I referenced above).  Clearly others need to embrace DST to
help inclusion become a reality.  To that end, its great to see that
Daniel Phillips and the other zumastor folks will be putting DST
through its paces.

regards,
Mike

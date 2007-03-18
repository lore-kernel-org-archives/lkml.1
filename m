Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXCRWgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXCRWgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXCRWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:36:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbXCRWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:36:12 -0400
Date: Mon, 19 Mar 2007 00:36:53 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Eric W. Biederman" <ebiederman@lnxi.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
Message-ID: <20070318223653.GO11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318202559.GD11078@mellanox.co.il>
	<m3tzwi8a20.fsf@maxwell.lnxi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3tzwi8a20.fsf@maxwell.lnxi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Eric W. Biederman <ebiederman@lnxi.com>:
> Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
> 
> "Michael S. Tsirkin" <mst@dev.mellanox.co.il> writes:
> 
> >> > Why is neighbour->dev changed here?
> >> 
> >> It holds reference to device and prevents its destruction.
> >> If dst is held somewhere, we cannot destroy the device and deadlock
> >> while unregister.
> >
> > BTW, can this ever happen for the loopback device itself?
> > Is it ever unregistered?
> 
> Well I don't think the loopback device is currently but as soon
> as we get network namespace support we will have multiple loopback
> devices and they will get unregistered when we remove the network
> namespace.

Hmm. Then the code moving dst->dev to point to the loopback
device will have to be fixed too. I'll post a patch a bit later.

-- 
MST

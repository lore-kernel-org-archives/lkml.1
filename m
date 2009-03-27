Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZC0HaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZC0HaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZC0H3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:29:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44806
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbZC0H3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:29:53 -0400
Date: Fri, 27 Mar 2009 00:29:40 -0700 (PDT)
Message-Id: <20090327.002940.55045245.davem@davemloft.net>
To: rdreier@cisco.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RDMA/nes: Fix mis-merge
From: David Miller <davem@davemloft.net>
In-Reply-To: <ada8wmru9hm.fsf@cisco.com>
References: <alpine.LFD.2.00.0903261638360.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903261639150.3994@localhost.localdomain>
	<ada8wmru9hm.fsf@cisco.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Mar 2009 16:53:25 -0700

>  > Btw, as far as I can tell, that function had never been tested with any 
>  > polling. It had a line like
>  > 
>  > 	netif_napi_add(netdev, &nesvnic->napi, nes_netdev_poll, 128);
>  > 
>  > but that line was _before_ 'nesvnic' was actually initialized (well, it 
>  > had been initialized to NULL, so it passed in some NULL-pointer-offset to 
>  > that function).
> 
> Yes, looks like the bug was introduced by d0929553 ("infiniband: convert
> nes driver to net_device_ops").  And unfortunately the nesvnic=NULL
> initialization stopped gcc from warning about used-uninitialized I
> guess.  I'll test the final merge out...

Sorry about that, thanks for working this out Roland.

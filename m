Return-Path: <linux-kernel-owner+w=401wt.eu-S1762403AbZCZXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbZCZXxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762194AbZCZXx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:53:29 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:18116 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762315AbZCZXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:53:27 -0400
X-IronPort-AV: E=Sophos;i="4.38,429,1233532800"; 
   d="scan'208";a="162385127"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RDMA/nes: Fix mis-merge
References: <20090326.152515.43533230.davem@davemloft.net>
	<alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
	<adahc1fuarm.fsf_-_@cisco.com>
	<20090326.163114.131582923.davem@davemloft.net>
	<alpine.LFD.2.00.0903261638360.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903261639150.3994@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 26 Mar 2009 16:53:25 -0700
In-Reply-To: <alpine.LFD.2.00.0903261639150.3994@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 26 Mar 2009 16:41:15 -0700 (PDT)")
Message-ID: <ada8wmru9hm.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Mar 2009 23:53:25.0383 (UTC) FILETIME=[0D8E3970:01C9AE6E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Btw, as far as I can tell, that function had never been tested with any 
 > polling. It had a line like
 > 
 > 	netif_napi_add(netdev, &nesvnic->napi, nes_netdev_poll, 128);
 > 
 > but that line was _before_ 'nesvnic' was actually initialized (well, it 
 > had been initialized to NULL, so it passed in some NULL-pointer-offset to 
 > that function).

Yes, looks like the bug was introduced by d0929553 ("infiniband: convert
nes driver to net_device_ops").  And unfortunately the nesvnic=NULL
initialization stopped gcc from warning about used-uninitialized I
guess.  I'll test the final merge out...

 - R.

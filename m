Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbYGUCn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbYGUCn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbYGUCnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 22:43:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24156 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759604AbYGUCnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 22:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hf+IafF0D0RR5RqDEzgYCrmohNLdhCYZ8DLVpcpimyeQ3VzHCJERQV/KliRtU29vKf
         yWqtAyf6dk8bDrDpDXXQeYDUPxTFfMUifiFjyi8kIG9MCceVWgV07UdmHz0hGOk0Imb2
         EzkN2GSMvmxQNzvZ8VNF6wkAEQhChEAoCWwV8=
Date: Mon, 21 Jul 2008 06:40:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20080721024056.GA4800@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org> <20080720.180304.51601407.davem@davemloft.net> <20080721010952.GA4822@martell.zuzino.mipt.ru> <20080720.181440.122144107.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720.181440.122144107.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, the problem is really this buglet:

	BUG_ON(q == &noop_qdisc);
	__netif_schedule
	netif_tx_wake_queue
	netif_wake_queue
	atl1_check_link
	atl1_up		or	atlx_link_chg_task
				run_workqueue



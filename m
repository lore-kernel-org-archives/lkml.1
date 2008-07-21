Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYGUL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYGUL7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYGUL7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:59:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:48288 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYGUL7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UaOhn8ol/fXH3BbBnHOtwyahgftwy+w3pZcYC7UxudGzrOhLhljgPuAdPVI+9kE8Ic
         4NoMTwQ2BTpSPan6u5R8p+QWhg2F8nUu/AbayPALdQDhYI/5O6PeNud+GzZTlNG2Hycg
         BFzQqpLuko1R/xB5ARrkf6NnqAkN7eTYpr2OA=
Date: Mon, 21 Jul 2008 15:57:42 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jeffrey.t.kirsher@intel.com
Subject: Re: [GIT]: Networking
Message-ID: <20080721115742.GA4871@martell.zuzino.mipt.ru>
References: <20080720.181440.122144107.davem@davemloft.net> <20080721024056.GA4800@martell.zuzino.mipt.ru> <20080720.194856.92564555.davem@davemloft.net> <20080720.221106.201055562.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720.221106.201055562.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 10:11:06PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 20 Jul 2008 19:48:56 -0700 (PDT)
> 
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Date: Mon, 21 Jul 2008 06:40:56 +0400
> > 
> > > OK, the problem is really this buglet:
> > > 
> > > 	BUG_ON(q == &noop_qdisc);
> > > 	__netif_schedule
> > > 	netif_tx_wake_queue
> > > 	netif_wake_queue
> > > 	atl1_check_link
> > > 	atl1_up		or	atlx_link_chg_task
> > > 				run_workqueue
> > 
> > Thanks for the backtrace I'll work on fixing this.
> 
> [ Jeff and co., this is basically the kind of patch I want
>   to see eventually for the Intel drivers too... ]
> 
> Alexey, please try this patch:
> 
> atl1: Do not wake queue before queue has been started.

Patch helps and networking is back with and without using netconsole,
thank you!

Also wan to say, 8139too driver survived multiqueue TX changes fine.


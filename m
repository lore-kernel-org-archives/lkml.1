Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYGWKSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYGWKSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 06:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYGWKSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 06:18:31 -0400
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1046 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751263AbYGWKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 06:18:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 25162
Date: Wed, 23 Jul 2008 12:18:27 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Alessandro Guido <ag@alessandroguido.name>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] skge: resolve tx multiqueue bug
Message-ID: <20080723101827.GA2236@gentoox2.trippelsdorf.de>
References: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com> <20080721.092027.14394005.davem@davemloft.net> <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com> <20080723054039.GA2272@gentoox2.trippelsdorf.de> <4886F0C5.7040605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4886F0C5.7040605@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 04:50:13PM +0800, Wang Chen wrote:
> Markus Trippelsdorf said the following on 2008-7-23 13:40:
> > On Tue, Jul 22, 2008 at 11:54:26AM +0200, Alessandro Guido wrote:
> >> Got a WARNING this morning (2.6.26-05752-g93ded9b) and I think it's related.
> > 
> > Same thing here (latest git):
> > 
> > skge eth1: enabling interface
> > skge eth1: disabling interface
> > ------------[ cut here ]------------
> > WARNING: at net/core/dev.c:1344 __netif_schedule+0x24/0x6d()
> > Pid: 1904, comm: ip Not tainted 2.6.26-06077-gc010b2f #33
> >  [<ffffffff8020b3eb>] system_call_after_swapgs+0x7b/0x80
...
> > ---[ end trace 92936ef183e09876 ]---
> > skge eth1: enabling interface
> > skge eth1: Link is up at 100 Mbps, full duplex, flow control both
> > 
> 
> Markus, please try this.
> 
> - Add netif_start_queue() in ->open()
> - netif_carrier_*() is enough, remove netif_*_queue()

Unfortunately, your patch does not fix this. I still get the same warning.

-- 
Markus

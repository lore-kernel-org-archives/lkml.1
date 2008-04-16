Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbYDPQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbYDPQ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYDPQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:59:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYDPQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:59:44 -0400
Date: Wed, 16 Apr 2008 09:59:38 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: X or AF_UNIX and order 3 allocation
Message-Id: <20080416095938.66d798e4.zaitcev@redhat.com>
In-Reply-To: <20080416085213.1e55bd1e@extreme>
References: <20080415211055.882e67fe.zaitcev@redhat.com>
	<20080415.215144.87148045.davem@davemloft.net>
	<20080416085213.1e55bd1e@extreme>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 08:52:13 -0700, Stephen Hemminger <shemminger@vyatta.com> wrote:

> > > Not sure if the problem is caused by X or kernel, but this is what
> > 
> > It seems to be the b44 driver doing a large huge order allocation.
> > 
> > That driver only asks for (1536 + 30 + 64) bytes, so I suppose part of
> > the problem is that SLAB is using an order 3 allocation to satisfy
> > that.

> The chip needs memory below 1G for DMA, perhaps low memory is getting
> exhausted.

The failure corresponds to memory pressure (from yum), but the real issue
is the lack of order 3 areas. We're talking a 32KB chunk! Why would anyone
need that much? Crazy!

Apr 13 18:19:14 niphredil kernel: Xorg: page allocation failure. order:3, mode:0x4020

I blame SLUB. Things like the above never happened with SLAB.

-- Pete

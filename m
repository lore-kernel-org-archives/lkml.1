Return-Path: <linux-kernel-owner+w=401wt.eu-S1422720AbXDRJaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422720AbXDRJaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422716AbXDRJaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:30:19 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58273 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422720AbXDRJaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:30:18 -0400
Date: Wed, 18 Apr 2007 13:29:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Patrick McHardy <kaber@trash.net>
Cc: Pavel Emelianov <xemul@sw.ru>, David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
Message-ID: <20070418092903.GA16910@2ka.mipt.ru>
References: <4625D3D2.9030507@sw.ru> <20070418081707.GA29267@2ka.mipt.ru> <4625D637.2040308@trash.net> <20070418084206.GA4241@2ka.mipt.ru> <4625DBE2.5090402@trash.net> <20070418090720.GA25070@2ka.mipt.ru> <4625E202.8040604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <4625E202.8040604@trash.net>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 18 Apr 2007 13:29:09 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 11:16:50AM +0200, Patrick McHardy (kaber@trash.net) wrote:
> > That is what I referred to as error path. Btw, with positive return
> > value we end up in subsequent call to input which will free callback
> > under lock as expected.
> 
> 
> No, nothing is going to call netlink_dump after the initial call since
> the socket is gone.

Argh, userspace socket's sk_data_rady() if dump returned positive value.
So, callback is not freed to allow to put several pages before
NLMSG_DONE via single dump?

-- 
	Evgeniy Polyakov

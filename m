Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXDRISM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXDRISM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXDRISM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:18:12 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33736 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbXDRISL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:18:11 -0400
Date: Wed, 18 Apr 2007 12:17:07 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Pavel Emelianov <xemul@sw.ru>
Cc: David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Patrick McHardy <kaber@trash.net>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
Message-ID: <20070418081707.GA29267@2ka.mipt.ru>
References: <4625D3D2.9030507@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <4625D3D2.9030507@sw.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 18 Apr 2007 12:17:19 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 12:16:18PM +0400, Pavel Emelianov (xemul@sw.ru) wrote:
> Sorry, I forgot to put netdev and David in Cc when I first sent it.
> 
> There is a race between netlink_dump_start() and netlink_release()
> that can lead to the situation when a netlink socket with non-zero
> callback is freed.

Out of curiosity, why not to fix a netlink_dump_start() to remove
callback in error path, since in 'no-error' path it removes it in
netlink_dump().

And, btw, can release method be called while socket is being used, I
thought about proper reference counters should prevent this, but not
100% sure with RCU dereferencing of the descriptor.

-- 
	Evgeniy Polyakov

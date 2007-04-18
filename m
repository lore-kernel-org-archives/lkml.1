Return-Path: <linux-kernel-owner+w=401wt.eu-S1030636AbXDRIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030636AbXDRIpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030521AbXDRIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:45:30 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58751 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030202AbXDRIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:45:29 -0400
Date: Wed, 18 Apr 2007 12:44:16 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Pavel Emelianov <xemul@sw.ru>
Cc: David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Patrick McHardy <kaber@trash.net>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
Message-ID: <20070418084416.GB4241@2ka.mipt.ru>
References: <4625D3D2.9030507@sw.ru> <20070418081707.GA29267@2ka.mipt.ru> <4625D7A8.5030209@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <4625D7A8.5030209@sw.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 18 Apr 2007 12:44:26 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 12:32:40PM +0400, Pavel Emelianov (xemul@sw.ru) wrote:
> Evgeniy Polyakov wrote:
> > On Wed, Apr 18, 2007 at 12:16:18PM +0400, Pavel Emelianov (xemul@sw.ru) wrote:
> >> Sorry, I forgot to put netdev and David in Cc when I first sent it.
> >>
> >> There is a race between netlink_dump_start() and netlink_release()
> >> that can lead to the situation when a netlink socket with non-zero
> >> callback is freed.
> > 
> > Out of curiosity, why not to fix a netlink_dump_start() to remove
> > callback in error path, since in 'no-error' path it removes it in
> 
> Error path is not relevant here. The problem is that we
> keep a calback on a socket that is about to be freed.

Yes, you are right, that it will not be freed in netlink_release(), 
but it will be freed in netlink_dump() after it is processed (in no-error 
path only though).

-- 
	Evgeniy Polyakov

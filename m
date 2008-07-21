Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYGUV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYGUV1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYGUV1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:27:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53999 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYGUV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:27:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4884FF00.30101@s5r6.in-berlin.de>
Date: Mon, 21 Jul 2008 23:26:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080719 SeaMonkey/1.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at net/core/dev.c:1328!
References: <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org>	<20080721.120052.123606398.davem@davemloft.net>	<4884E174.5030802@s5r6.in-berlin.de> <20080721.131129.244101157.davem@davemloft.net>
In-Reply-To: <20080721.131129.244101157.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> You should only do a netif_stop_queue() in your device
> initialization, at the very end of ->open() processing
> when you've fully committed to returning success.
> 
> You should not, in particular, be doing a netif_wake_queue()
> before you've even done a netif_start_queue().
> 
> Many of these drivers are using netif_{stop,wake}_queue()
> to stop packet flow, in particular when link state changes,
> and netif_carrier_{on,off}() already does all of that for
> you.
> 
> Really, anything outside of:
> 
> 1) netif_start_queue() in ->open()
> 2) netif_stop_queue() in ->stop()
> 3) netif_{stop,wake}_queue() in the TX packet handling path
> 
> is superfluous.

Thanks, I wasn't aware of this.  I'll try to fix up eth1394 this way as 
time permits.
-- 
Stefan Richter
-=====-==--- -=== =-=-=
http://arcgraph.de/sr/

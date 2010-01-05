Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987Ab0AEVsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0AEVsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847Ab0AEVsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:48:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0AEVsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:48:40 -0500
Date: Tue, 5 Jan 2010 23:45:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: cfriesen@nortel.com, eric.dumazet@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
Message-ID: <20100105214524.GA31301@redhat.com>
References: <20100105185732.GA30346@redhat.com> <4B43AEF6.6050701@nortel.com> <20100105.134218.258781374.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105.134218.258781374.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:42:18PM -0800, David Miller wrote:
> From: "Chris Friesen" <cfriesen@nortel.com>
> Date: Tue, 05 Jan 2010 15:28:22 -0600
> 
> > On 01/05/2010 12:57 PM, Michael S. Tsirkin wrote:
> >> When sending packets with a packet socket it is often necessary to set
> >> protocol in msg_name: otherwise the protocol field in the skb will not
> >> be set correctly.
> > 
> > What about automatically detecting the protocol from the data being sent
> > to avoid the necessity of specifying it in the first place?
> 
> This limits packet socket usage to only protocols the kernel is aware
> of, defeating part of the usefulness of the packet socket facility.

We could do this if the protocol is ETH_P_ALL -  skbs end up with this
protocol currently when sendmsg does not have msgname and when socket is
set up to listen for all packets.  It's not a valid protocol value, is
it?

-- 
MST

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbYBMBm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbYBMBm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYBMBmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:42:05 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:57125 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188AbYBMBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:42:00 -0500
Message-ID: <47B24AE1.7040709@opengridcomputing.com>
Date: Tue, 12 Feb 2008 19:41:53 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Fail loopback connections.
References: <20080212220929.24442.76874.stgit@dell3.ogc.int> <adafxvxvgz3.fsf@cisco.com>
In-Reply-To: <adafxvxvgz3.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> applied, although:
> 
>  > +static void is_loopback_dst(struct iw_cm_id *cm_id)
>  > +{
>  > +	struct net_device *dev;
>  > +	
>  > +	dev = ip_dev_find(&init_net, cm_id->remote_addr.sin_addr.s_addr);
>  > +	if (!dev)
>  > +		return 0;
>  > +	dev_put(dev);
>  > +	return 1;
>  > +}
> 
> is there any way this could trigger when it should, like if I'm trying
> to make a connection from one local device to a different local device
> (which should work fine)?
> 

As far as I can tell, if the app does a rdma_resolve_addr() on the dst 
addr (which is a local address), then the routing lookup will find the 
local interface with that dst addr, and that device will be used for the 
connect.  IE src and dst devices are the same.

Maybe if the app does an explicit bind to the addr on one device, then 
connects to the addr on the other device.  But that's not gonna work 
either, I think.  I still think it will resolve to one device and that 
device cannot do loopback...


Steve.

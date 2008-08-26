Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYHZUwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYHZUwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYHZUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:52:22 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:60274 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbYHZUwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:52:21 -0400
Date: Wed, 27 Aug 2008 00:51:58 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080826205158.GA15266@2ka.mipt.ru>
References: <200808220457.40892.denys@visp.net.lb> <20080826201406.GA24827@2ka.mipt.ru> <48B46B48.7030609@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B46B48.7030609@cosmosbay.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 10:44:56PM +0200, Eric Dumazet (dada1@cosmosbay.com) wrote:
> >Do you have any packet sockets in this system? Like running dhcp daemon?
> >
> 
> Another way to see this problem can be to start a sniffer on the machine, 
> even with a restrictive pcap filter, to check if performance change or not. 
> (It should decrease)

Or just check /proc/net/packet iirc.
Anyway, having at least one packet socket ends up with timestamping of
each packet, so you will get fair load of getnstimeofday() in that case.

> For example, I believe that running "ping" could have the same effect
> (increasing netstamp_needed variable : every incoming packet has to be 
> timestamped)
> 
> So beware of pings, traceroute and other networking tools...

Yup, this innocent toys can end up with this such behaviour on modern
highly loaded machines.

-- 
	Evgeniy Polyakov

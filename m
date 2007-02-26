Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXBZMVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXBZMVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965062AbXBZMVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:21:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:44019 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXBZMVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:21:18 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: John <linux.kernel@free.fr>
Subject: Re: CLOCK_MONOTONIC datagram timestamps by the kernel
Date: Mon, 26 Feb 2007 13:20:57 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, mingo@elte.hu,
       zippel@linux-m68k.org, tglx@timesys.com, akpm@linux-foundation.org,
       jbohac@suse.cz
References: <45E1FFCC.50201@free.fr> <45E2B5E4.7020208@free.fr>
In-Reply-To: <45E2B5E4.7020208@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261320.57726.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mr Anonymous,

> 
> My app expects a stream of UDP datagrams containing compressed video.
> These datagrams have been time stamped by the source using a high 
> resolution clock.

Why do you need another time stamp them? 
> 
> The video stream is played out in real-time. I buffer several packets, 
> then repeatedly arm a one-shot timer (with TIMER_ABSTIME set) to wait 
> until it's time to send the oldest packet.
> 
> AFAIU, if I use the CLOCK_REALTIME clock in my app, and if the sysadmin 
> changes the date, hell will break loose in my app.

Only if your app cannot handle time going backwards.

> I suppose that if I change sock_get_timestamp() in core/sock.c to call 
> __get_realtime_clock_ts() instead of do_gettimeofday() I'll break 50 
> billion applications (ping? traceroute?) that expect a struct timeval?

Not that many, but some probably. 

Letting the kernel do the time stamping is usually quite useless anyways. 
You can as well do it in your application when you receive it. After all
you're interested in when you can read the packet in your app, 
not when the driver processes it.

The kernel time stamping is mainly for sniffing applications that want
to know exactly what's going on on the wire. But even then it's fairly
arbitary because it can be a long time between the packet arriving 
on the PHY and being processed by the driver.

-Andi

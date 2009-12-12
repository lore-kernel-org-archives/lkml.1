Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZLLJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZLLJDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 04:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZLLJDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 04:03:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48702
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758029AbZLLJDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 04:03:35 -0500
Date: Sat, 12 Dec 2009 01:03:40 -0800 (PST)
Message-Id: <20091212.010340.227842186.davem@davemloft.net>
To: lists@nerdbynature.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.01.0912112335440.2915@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912112335440.2915@bogon.housecafe.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Kujau <lists@nerdbynature.de>
Date: Fri, 11 Dec 2009 23:43:10 -0800 (PST)

> today I upgraded from 2.6.32-rc7 to the latest -git (mainline) and after a 
> few hours the messages below appeared in the log. Apparently "privoxy" was 
> very busy handling connections, but the messages never appeared with 
> earlier kernels. 
> 
> Full dmesg & .config is on:
> http://nerdbynature.de/bits/2.6.33-git/inet_accept/

Yeah I started seeing this on one of my machines too, the
assertion is:

	WARN_ON(newsk->sk_state == TCP_SYN_RECV);

I wonder if some of the refactorings we did to allow per-route
SACK/DSACK/etc. controls messed some sequence of state changes
on TCP sockets.  But I can't find anything obvious in those
commits.

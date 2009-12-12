Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZLLJWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZLLJWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 04:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZLLJWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 04:22:07 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:33189 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZLLJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 04:22:06 -0500
Message-ID: <4B2360BF.5000102@gmail.com>
Date: Sat, 12 Dec 2009 10:22:07 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: lists@nerdbynature.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
References: <alpine.DEB.2.01.0912112335440.2915@bogon.housecafe.de> <20091212.010340.227842186.davem@davemloft.net>
In-Reply-To: <20091212.010340.227842186.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 12 Dec 2009 10:22:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/12/2009 10:03, David Miller a écrit :
> From: Christian Kujau <lists@nerdbynature.de>
> Date: Fri, 11 Dec 2009 23:43:10 -0800 (PST)
> 
>> today I upgraded from 2.6.32-rc7 to the latest -git (mainline) and after a 
>> few hours the messages below appeared in the log. Apparently "privoxy" was 
>> very busy handling connections, but the messages never appeared with 
>> earlier kernels. 
>>
>> Full dmesg & .config is on:
>> http://nerdbynature.de/bits/2.6.33-git/inet_accept/
> 
> Yeah I started seeing this on one of my machines too, the
> assertion is:
> 
> 	WARN_ON(newsk->sk_state == TCP_SYN_RECV);
> 
> I wonder if some of the refactorings we did to allow per-route
> SACK/DSACK/etc. controls messed some sequence of state changes
> on TCP sockets.  But I can't find anything obvious in those
> commits.

Could it be about syncookies patches ?

tcp_create_openreq_child() changes ?


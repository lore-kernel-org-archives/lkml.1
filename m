Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYCOIrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYCOIrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 04:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYCOIrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 04:47:32 -0400
Received: from mail.reagi.com ([195.60.188.80]:50866 "EHLO mail.reagi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbYCOIrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 04:47:31 -0400
Message-ID: <47DB8D1C.7020006@oxeva.fr>
Date: Sat, 15 Mar 2008 09:47:24 +0100
From: Gabriel Barazer <gabriel@oxeva.fr>
Organization: OXEVA
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, netdev@kernel.org
Subject: Re: [2.6.24.3][net] bug: TCP 3rd handshake abnormal timeouts
References: <47DB28E9.4050309@oxeva.fr> <20080315065739.GL8953@1wt.eu> <20080315065849.GA11817@1wt.eu>
In-Reply-To: <20080315065849.GA11817@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thanks for the netdev Cc, I didn't know where to write to the "network 
guys".

By the way thanks for replying. It's hard to explain and describe a 
problem when you know people will ask you hundreds of questions related 
to application-level problems, or not reply because web/mysql problems 
are so common and generally not related to any kernel issue.

On 03/15/2008 7:58:49 AM +0100, Willy Tarreau <w@1wt.eu> wrote:
> 
> You should carefully check the the SYN-ACK received by the client has a
> correct checksum ("cksum OK" in tcpdump output). It would be possible
> that for some reason, something on the network randomly corrupts it.

I used to use TCP offloading one time, and by the way never had a 
problem with it. Besides just to be sure, I have been able to reproduce 
the problem without any offload engine enabled (= not compiled into the 
kernel, mainly because it seems to hang the kernel at boot in 2.6.24.3). 
So I assume that is not the problem

I use wireshark to analyse my pcap files and it says the checksum is 
correct on all packets.

> Also, you say you have netfilter with conntrack. Is this on the client ?
> If so, you should try disabling it to rule out any possible bug in the
> connection tracking.

I have the conntrack  on both the client and server, and unfortunately 
can't disable it now on the client (I use it only for the REDIRECT 
target on a precise destination address and port, not MySQL related), 
however I will test today and disable it on the server, after I get some 
sleep (although I think the issue is on the client).

Gabriel

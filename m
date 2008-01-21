Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYAUVbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYAUVbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYAUVbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:31:23 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:44135 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYAUVbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:31:22 -0500
Message-ID: <47950F1D.4010508@cosmosbay.com>
Date: Mon, 21 Jan 2008 22:31:09 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <4794F848.9020402@nortel.com>
In-Reply-To: <4794F848.9020402@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 21 Jan 2008 22:31:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> I've done some further digging, and it appears that one of the problems 
> we may be facing is very high instantaneous traffic rates.
> 
> Instrumentation showed up to 222K packets/sec for short periods (at 
> least 1.1 ms, possibly longer), although the long-term average is down 
> around 14-16K packets/sec.

Instrumentation done where exactly ?

tcpdump on the host will lie, since timestamps are probably going to be host 
timestamps, giving the time of RX dequeing, and not time of packets arrival 
given by NIC.

> 
> If I bump the rx ring size up to 4096, we can handle all the packets and 
> we still have 44% idle on cpu0 and 27% idle on cpu1.
> 
> Is there anything else we can do to minimize the latency of network 
> packet processing and avoid having to crank the rx ring size up so high?
> 


You have some tasks that disable softirqs too long. Sometimes, bumping RX ring 
size is OK (but you will still have delays), sometimes it is not an option, 
since 4096 is the limit on current hardware.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYJTKrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYJTKrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYJTKq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:46:59 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:36736 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYJTKq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:46:59 -0400
Message-ID: <48FC61A0.7010003@motion-twin.com>
Date: Mon, 20 Oct 2008 12:46:56 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: swivel@shells.gnugeneration.com
CC: linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
References: <48FC4066.9060303@motion-twin.com> <20081020101549.GH2811@fc6222126.aspadmin.net>
In-Reply-To: <20081020101549.GH2811@fc6222126.aspadmin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> We have Shorewall installed and enabled, but what seems strange is that 
>> the problem depends on multithreading. It also occurs much more often on 
>> the 4 core machines than on a 2 core ones (both with Hyperthreading 
>> activated). We're using kernel 2.6.20-15-server (#2 SMP) provided by Ubuntu.
>>
>> Any tip on we could fix that or investigate further would be 
>> appreciated. After one month of debugging we're really out of solution now.
>>
>> Best,
>> Nicolas
> 
> Your usage pattern is a very common one, I highly doubt you are experiencing
> a kernel bug here or many people (including myself) would be complaining.
> 
> Shorewall sounds like it might be suspect, are FIN's not coming in when the
> remote closes?  You can look in the output of netstat to see what state the
> TCP is in, still ESTABLISHED?

Yes, it's still ESTABLISHED, but we can't see the corresponding 
connection on the other machine while running netstat. I'm not a TCP 
expert, so I'm not sure in which case this can occur.

I agree with your comment in general, except that we have been running 
the same application in single-thread environment for years without 
running into this very specific problem.

The only logs we get in the dmesg are the following :

either (a few everyday) :

[10742708.006350] TCP: Treason uncloaked! Peer 213.209.177.218:32924/80 
shrinks window 4049064122:4049064123. Repaired.

Or (more often) :

[10755036.856217] Shorewall:net2all:DROP:IN=eth0 OUT= 
MAC=00:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:00 SRC=60.238.83.204 
DST=XX.XX.XX.43 LEN=404 TOS=0x00 PREC=0x00 TTL=114 ID=12366 PROTO=UDP 
SPT=1057 DPT=1434 LEN=384

Both SRC/DST IPs does not correspond to the connections that are 
stalled, since they occur on the local network.

Best,
Nicolas

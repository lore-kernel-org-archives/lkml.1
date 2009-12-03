Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZLCQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZLCQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZLCQ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:58:25 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:46441 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbZLCQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:58:24 -0500
Message-ID: <4B17ED8D.7050409@nortel.com>
Date: Thu, 03 Dec 2009 10:55:41 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com> <4B154B29.1030807@cosmosbay.com> <4B155252.1040604@nortel.com> <4B1557CC.4060503@gmail.com>
In-Reply-To: <4B1557CC.4060503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2009 16:58:16.0847 (UTC) FILETIME=[CF0241F0:01CA7439]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 11:52 AM, Eric Dumazet wrote:

> But be careful of sender tcp stack : It might be delayed a bit,
> because it waits for receiver to open its window (slow start)
> 
> You probably need something like
> 
> while (1) {
> 	send(fd1, buffer, 2Kbytes);
> 	sleep(2); // let tcp stack flush its write buffers
> 	display_sk_rmem_alloc(fd2);
> }

Ah, that makes a difference.  But the results (see below) still look
odd.  For this test, /proc/sys/net/core/rmem_default is 118784.  For
some reason sk_rmem_alloc gets bumped by 16KB when I only send 2KB of
data, and it drops back down again every 6 packets.

Chris



used: 16848
used: 33696
used: 50544
used: 67392
used: 84240
used: 101088
used: 30736
used: 47584
used: 64432
used: 81280
used: 98128
used: 114976
used: 44624
used: 61472
used: 78320
used: 95168
used: 112016
used: 128864
used: 58512
used: 75360
used: 92208
used: 109056
used: 125904
used: 142752
used: 72400
used: 89248
used: 106096
used: 122944
used: 139792
used: 156640
used: 86288
used: 103136
used: 119984
used: 136832
used: 153680
used: 170528
used: 100176
used: 117024
used: 133872
used: 150720
used: 167568
used: 184416
used: 114064
used: 130912
used: 147760
used: 164608
used: 181456
used: 198304
used: 127952
used: 144800
used: 161648
used: 178496
used: 195344
used: 212192
used: 141840
used: 158688
used: 175536
used: 192384
used: 209232
used: 226080
used: 155728
used: 172576
used: 189424
used: 206272
used: 223120
used: 239968
used: 169616
used: 186464
used: 203312
used: 220160
used: 237008
used: 253856
used: 183504
used: 200352
used: 217200
used: 234048
used: 250896
used: 267744
used: 197392
used: 214240
used: 231088
used: 247936
used: 264784
used: 281632
used: 211280
used: 228128
used: 244976

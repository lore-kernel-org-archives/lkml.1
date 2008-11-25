Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYKYV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYKYV17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYKYV1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:27:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYKYV1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:27:50 -0500
Message-ID: <492C6C9B.3060000@sandeen.net>
Date: Tue, 25 Nov 2008 15:22:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Stian Jordet <liste@jordet.net>
CC: Sven-Haegar Koch <haegar@sdinet.de>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
References: <1226760254.5089.11.camel@chevrolet>	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>	<1227476908.32357.5.camel@chevrolet>	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>	<1227485956.5145.10.camel@chevrolet>	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>	<1227569808.5039.6.camel@chevrolet>	<alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de> <1227645887.7992.10.camel@chevrolet>
In-Reply-To: <1227645887.7992.10.camel@chevrolet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stian Jordet wrote:
> ti., 25.11.2008 kl. 01.09 +0100, skrev Sven-Haegar Koch:
>> I had the same problem when I tried it on my laptop (T60) - using it on 
>> the unencrypted root filesystem (with /usr/src) took ages, using it on 
>> the LUKS encrypted /home was blasing fast - on the same disk.
>>
>> This test was some time ago with something like 2.6.20 or 2.6.24 - I 
>> gave up and reformatted / with ext3 as I needed the machine.
>>
>> I think barriers were the problem, they seem to cost performance like 
>> hell, especially for operations with many small files. My laptop used 
>> barriers for xfs on the direct partition, but not on crypto drivermapper 
>> mounts.
>>
>> So perhaps try mounting with nobarrier and see if the speed problem goes 
>> away - but know that you sacrifice some crash-resilience when doing so.
> 
> Barriers were the problem indeed. My old system had no problems with
> barriers, but here it did an incredible difference.

Depending on the old system, perhaps its storage did not allow the
barriers to be honored, so after xfs saw a test barrier write fail at
mount time, it disabled them ... you'd see a message if that were the
case, FWIW.

-Eric

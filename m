Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYKXXw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYKXXw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYKXXwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:52:50 -0500
Received: from lucidpixels.com ([75.144.35.66]:47831 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYKXXwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:52:50 -0500
Date: Mon, 24 Nov 2008 18:52:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stian Jordet <liste@jordet.net>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227569808.5039.6.camel@chevrolet>
Message-ID: <alpine.DEB.1.10.0811241851160.11882@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet>  <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>  <1227476908.32357.5.camel@chevrolet>  <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>  <1227485956.5145.10.camel@chevrolet> 
 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan> <1227569808.5039.6.camel@chevrolet>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Nov 2008, Stian Jordet wrote:

> ma., 24.11.2008 kl. 04.50 -0500, skrev Justin Piszcz:
>> While there still may be something else wrong, the first problem I see is
>> your sunit and swidth are set to 0.
>>
>> Please read, a good article on what they are and how to set them:
>> http://www.socalsysadmin.com/
>
> Oh, this was new to me. But the setting didn't change anything. I can
> copy one large file between the xfs and ext3 disk (both ways), and I get
> speeds between 160 and 200 MB/s. But unpacking the kernel source takes
> between 5 and 10 minutes on the xfs disk, and a mere 15 seconds on the
> ext3... (and it also used to take between 5 and 10 minutes when I had
> xfs on the raid0, so it doesn't seem to be hardware related...)
>
> If anyone has anything more I can try before I do the lengthy process of
> backup 1TB, reformat and restore...
>
> Thanks :)
>
> Regards,
> Stian
>

When you 'unpack the kernel source' ext3 will cache it etc, best way to 
test:

/usr/bin/time cmd
or
time cmd

where cmd is: bash -c 'tar xvf file.tar; sync'

Make sure its a tar and not gzip/bzip2 (limited by CPU/etc)

The other option is the relatime you stated, use this instead:

defaults,noatime,logbufs=8,logbsize=262144

then tell me what you get
(instead of relatime)

Justin.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYKYBgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYKYBgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYKYBgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 20:36:07 -0500
Received: from sandeen.net ([209.173.210.139]:20334 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYKYBgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 20:36:06 -0500
Message-ID: <492B5684.2080107@sandeen.net>
Date: Mon, 24 Nov 2008 19:36:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Stian Jordet <liste@jordet.net>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
References: <1226760254.5089.11.camel@chevrolet>	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>	<1227476908.32357.5.camel@chevrolet>	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>	<1227485956.5145.10.camel@chevrolet>	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan> <1227569808.5039.6.camel@chevrolet>
In-Reply-To: <1227569808.5039.6.camel@chevrolet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stian Jordet wrote:
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

I don't know if the storage you're on passes barriers or not, but xfs
has barriers on by default, while ext3 does not.  ext3 will still likely
win the "untar a kernel" race, but for a fairer test, make the barrier
settings consistent between the two.

-Eric

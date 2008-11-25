Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbYKYJ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbYKYJ4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYKYJ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:56:26 -0500
Received: from lucidpixels.com ([75.144.35.66]:45629 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYKYJ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:56:25 -0500
Date: Tue, 25 Nov 2008 04:56:24 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Eric Sandeen <sandeen@sandeen.net>
cc: Stian Jordet <liste@jordet.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <492B5684.2080107@sandeen.net>
Message-ID: <alpine.DEB.1.10.0811250456010.16346@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet> <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com> <1227476908.32357.5.camel@chevrolet> <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan> <1227485956.5145.10.camel@chevrolet>
 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan> <1227569808.5039.6.camel@chevrolet> <492B5684.2080107@sandeen.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Nov 2008, Eric Sandeen wrote:

> Stian Jordet wrote:
>> ma., 24.11.2008 kl. 04.50 -0500, skrev Justin Piszcz:
>>> While there still may be something else wrong, the first problem I see is
>>> your sunit and swidth are set to 0.
>>>
>>> Please read, a good article on what they are and how to set them:
>>> http://www.socalsysadmin.com/
>>
>> Oh, this was new to me. But the setting didn't change anything. I can
>> copy one large file between the xfs and ext3 disk (both ways), and I get
>> speeds between 160 and 200 MB/s. But unpacking the kernel source takes
>> between 5 and 10 minutes on the xfs disk, and a mere 15 seconds on the
>> ext3... (and it also used to take between 5 and 10 minutes when I had
>> xfs on the raid0, so it doesn't seem to be hardware related...)
>>
>> If anyone has anything more I can try before I do the lengthy process of
>> backup 1TB, reformat and restore...
>
> I don't know if the storage you're on passes barriers or not, but xfs
> has barriers on by default, while ext3 does not.  ext3 will still likely
> win the "untar a kernel" race, but for a fairer test, make the barrier
> settings consistent between the two.
>
> -Eric
>

barriers enabled:

$ time bash -c 'tar xf linux-2.6.27.7.tar; sync'
block 573932: ** Block of NULs **
Total bytes read: 293857280 (281MiB, 1.9MiB/s)

real    2m40.643s
user    0m0.194s
sys     0m1.541s

barriers disabled:

time bash -c 'tar xf linux-2.6.27.7.tar; sync'
block 573932: ** Block of NULs **
Total bytes read: 293857280 (281MiB, 11MiB/s)

real    0m27.612s
user    0m0.182s
sys     0m1.617s



Return-Path: <linux-kernel-owner+w=401wt.eu-S1765096AbXGPRic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765096AbXGPRic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbXGPRiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:38:24 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7095 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXGPRiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:38:23 -0400
Date: Mon, 16 Jul 2007 19:37:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Brown <dmlb2000@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dm-crypt aes sha512 and I/O performance
Message-ID: <20070716173738.GD5195@kernel.dk>
References: <9c21eeae0707141718r16de38a7rac80458c168b5f05@mail.gmail.com> <9c21eeae0707160855g7f8ca115g272ba9d99a21ab6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c21eeae0707160855g7f8ca115g272ba9d99a21ab6e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, David Brown wrote:
> On 7/14/07, David Brown <dmlb2000@gmail.com> wrote:
>> I was forced to put full (almost) hard drive encryption on my laptop
>> so that all the Open Source Work I get paid to do will be protected in
>> case someone tries to steal it and so they won't find any personal
>> information about me if they get a hold of my laptop (because every
>> idiot keeps their entire life history on their computers).
>>
>> Besides the futility of the above statement I've been noticing some
>> oddities with how linux and dm-crypt handles I/O on the system.
>>
>> Now normally I get about 30Mb/s write speed I would expect some sort
>> of drop in performance due to the encryption but currently I'm getting
>> about 9Mb/s write speed and I'm kinda confused as to what the choke
>> point is and how to improve the write speed, if it can be.
>>
>> Currently both my swap and root are encrypted with the default debian
>> installer encryption and there's two kcryptd processes running. Now
>> from what I've noticed when I'm dumping data to disk they both seem to
>> be working, yet I'm not swapping or anything. So am I right to assume
>> that the two kcryptd processes are running in parallel encrypting the
>> data to the one root device? Also they only seem to be using 20% of
>> the processors they are running on, why isn't it 100%? I'm guessing
>> that the data isn't being either compressed or blown up when
>> encrypting using this encryption style (but I'm not an expert). Would
>> making more kcryptd threads increase the I/O speed (more processes
>> doing encrypting)? Is there a way to specify more threads of kcryptd?
>>
>> I'm kinda at a loss, so any help would be appreciated.
>> - David Brown
>>
>
> I should remember never to email the LKML during the weekend...
>
> Did anyone see this?
>
> I did some number crunching and with about 15Mb/s read and 9Mb/s write
> I end up copying files on the hard drive locally at about 3Mb/s
> (rounded). Which is really lame getting twice without encryption was
> much better.
>
> I'm using the ata_piix driver in the 2.6.22.1 kernel.

Try and blktrace the crypt device, perhaps? Do a simple dd from your
crypted device to /dev/null, and run blktrace on the device at the same
time. Just for a few seconds. Then check with blkparse if anything
obvious pops up.

-- 
Jens Axboe


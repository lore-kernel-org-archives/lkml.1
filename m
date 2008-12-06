Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYLFJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYLFJ0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 04:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYLFJ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 04:26:22 -0500
Received: from lucidpixels.com ([75.144.35.66]:46958 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbYLFJ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 04:26:21 -0500
Date: Sat, 6 Dec 2008 04:26:18 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       smartmontools-support@lists.sourceforge.net
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: Velociraptor drive related to the use of NCQ.
In-Reply-To: <alpine.DEB.1.10.0812050855140.4713@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812051857190.4906@p34.internal.lan>
References: <alpine.DEB.1.10.0812050602400.3188@p34.internal.lan> <alpine.DEB.1.10.0812050855140.4713@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, Justin Piszcz wrote:

>
>
> On Fri, 5 Dec 2008, Justin Piszcz wrote:
>
>> I swapped out my power supply, changed ALL cables and bought a $1000 raid
>> controller with BBU, the drives are still having problems, when writing to
>> them in a RAID10 configuration, it locks up the card:
>> 
>> SMART shows the same thing on many of the disks in the RAID10:
>> 
>> Error 1 occurred at disk power-on lifetime: 3708 hours (154 days + 12 
>> hours)
>>  When the command that caused the error occurred, the device was active or 
>> idle.
>
> I spoke to soon, turning off NCQ helped dramatically, it worked three times!
>
> writing to raid10
> dd: writing `file2': No space left on device
> 1430328+0 records in
> 1430327+0 records out
> 1499806973952 bytes (1.5 TB) copied, 3914.51 s, 383 MB/s
> Fri Dec  5 06:00:25 EST 2008
> writing to raid10
> dd: writing `file2': No space left on device
> 1430328+0 records in
> 1430327+0 records out
> 1499806973952 bytes (1.5 TB) copied, 4063.25 s, 369 MB/s
> Fri Dec  5 07:08:11 EST 2008
> writing to raid10
> dd: writing `file2': No space left on device
> 1430328+0 records in
> 1430327+0 records out
> 1499806973952 bytes (1.5 TB) copied, 3926.71 s, 382 MB/s
> Fri Dec  5 08:13:41 EST 2008
>
> Then it crashed again, with NCQ enabled, it would not even complete one test,
> So basically a new system, new PSU, new cables, its on a new APC UPS and the 
> problem persists even when all disks are on a RAID card, SW raid, it does not 
> matter, Velociraptors have problems, I think its time for me to get regular
> 1TiB disks and be done with it.
>
> Justin.
>
>

I have swapped my disks:

Removed my 12 velociraptors.
Inserted my old 12 raptor150s (all ADFD).

The 12 velociraptors are now in a test system using md/raid.
The 12 raptor 150s are now in my main machine w/3ware.

I am going to run the same tests, benchmarks, etc and see if any problems 
repeat with the 150s and I will also run a bunch more tests on the 
velociraptors as well.

So far no problems with the good ol' raptor 150s and I have been running 
the same dd test for the past 8 hours+ on the same raid type and settings 
as I had with the velociraptors:

Fri Dec  5 21:07:43 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2747.77 s, 273 MB/s
Fri Dec  5 21:53:32 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2742.29 s, 273 MB/s
Fri Dec  5 22:39:17 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2685.21 s, 279 MB/s
Fri Dec  5 23:24:05 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2600.05 s, 288 MB/s
Sat Dec  6 00:07:28 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2550.45 s, 294 MB/s
Sat Dec  6 00:50:02 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2507.31 s, 299 MB/s
Sat Dec  6 01:31:52 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2247.31 s, 334 MB/s
Sat Dec  6 02:09:22 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2248.2 s, 334 MB/s
Sat Dec  6 02:46:53 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2245.41 s, 334 MB/s
Sat Dec  6 03:24:22 EST 2008
dd: writing `/t/bigfile': No space left on device
715067+0 records in
715066+0 records out
749801271296 bytes (750 GB) copied, 2494.1 s, 301 MB/s
Sat Dec  6 04:05:59 EST 2008

So far no problems, just like before when I used to use these drives in 
the past, they are rock solid (will continue to test, the VRs are another 
story)-- more info soon to follow.

Justin.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031725Ab0B1J7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 04:59:35 -0500
Received: from lucidpixels.com ([75.144.35.66]:57662 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031648Ab0B1J7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 04:59:33 -0500
Date: Sun, 28 Feb 2010 04:59:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Asdo <asdo@shiftmail.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
In-Reply-To: <4B89BF36.3030901@shiftmail.org>
Message-ID: <alpine.DEB.2.00.1002280445390.16775@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <87zl2vsdxs.fsf@openvz.org> <alpine.DEB.2.00.1002261953350.8247@p34.internal.lan> <4B89BF36.3030901@shiftmail.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Asdo wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Sat, 27 Feb 2010, Dmitry Monakhov wrote:
>> 
>>> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>>> 
>>>> Hello,
>>>> 
>>>> Is it possible to 'optimize' ext4 so it is as fast as XFS for writes?
>>>> I see about half the performance as XFS for sequential writes.
>>>> 
>>>> I have checked the doc and tried several options, a few of which are 
>>>> shown
>>>> below (I have also tried the commit/journal_async/etc options but none of
>>>> them get the write speeds anywhere near XFS)?
>>>> 
>>>> Sure 'dd' is not a real benchmark, etc, etc, but with 10Gbps between 2
>>>> hosts I get 550MiB/s+ on reads from EXT4 but only 100-200MiB/s write.
>>>> 
>>>> When it was XFS I used to get 400-600MiB/s for writes for the same RAID
>>>> volume.
>>>> 
>>>> How do I 'speed' up ext4?  Is it possible?
> Hi Justin
> sorry for being OT in my reply (I can't answer your question unfortunately)
> You can really get 550MiB/sec through a 10gigabit ethernet connection?
Yes, I am capped by the disk I/O, the network card itself card does ~1 
gigabyte per second over iperf.  If I had two raid systems that 
did >= 1Gbyte/sec read+write AND enough PCI-e bandwidth, it is plausible to
see (large-files) transferring at 10Gbps speeds.

> I didn't think it was possible. Just a few years ago it seems to me there 
> were problems in obtaining a full gigabit out of 1Gigabit ethernet 
> adapters...
I have been running gigabit for awhile now and have been able to saturate
it for some time between Linux hosts.  If you are referring to windows and 
the transfer rates via samba, their networking stack did not get 'fixed' 
until Windows 7, otherwise it seemd like it was 'capped' at 40-60MiB/s, 
regardless of the HW.  With 7, you always get ~100MiB/s if your HW is fast 
enough.  A single Intel X25-E SSD can read > 200MiB/s as can many of the 
newer SSDs being released (the Micron 6Gbps) pusing 300MiB/s.  As SSDs 
become more mainstream, gigabit will become more and more of a bottleneck.

> Is it running some kind of offloading like TOE, or RDMA or other magic 
> things? (maybe by default... you can check something with ethtool 
Yes, check the features here (page 2/4), half way down:
http://www.intel.com/Assets/PDF/prodbrief/318349.pdf

> --show-offload eth0, but TOE isn't there)
> Or really computers became so fast and I missed something...?
PCI-express (for the bandwidth) (not PCI-X), jumbo frames (mtu=9000) 
and the 2.6 kernel.

> Sorry for the stupid question
> (pls note: I removed most CC recipients because I went OT)
>
> Thank you
>

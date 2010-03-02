Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0CBReN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:34:13 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:59074 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab0CBReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:34:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19341.19446.356359.99958@stoffel.org>
Date: Tue, 2 Mar 2010 12:33:42 -0500
From: "John Stoffel" <john@stoffel.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Dave Chinner <david@fromorbit.com>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] nfs: use 4*rsize readahead size
In-Reply-To: <1267539563.3099.43.camel@localhost.localdomain>
References: <20100224024100.GA17048@localhost>
	<20100224032934.GF16175@discord.disaster>
	<20100224041822.GB27459@localhost>
	<20100224052215.GH16175@discord.disaster>
	<20100224061247.GA8421@localhost>
	<20100224073940.GJ16175@discord.disaster>
	<20100226074916.GA8545@localhost>
	<20100302031021.GA14267@localhost>
	<1267539563.3099.43.camel@localhost.localdomain>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Trond" == Trond Myklebust <Trond.Myklebust@netapp.com> writes:

Trond> On Tue, 2010-03-02 at 11:10 +0800, Wu Fengguang wrote: 
>> Dave,
>> 
>> Here is one more test on a big ext4 disk file:
>> 
>> 16k	39.7 MB/s
>> 32k	54.3 MB/s
>> 64k	63.6 MB/s
>> 128k	72.6 MB/s
>> 256k	71.7 MB/s
>> rsize ==> 512k  71.7 MB/s
>> 1024k	72.2 MB/s
>> 2048k	71.0 MB/s
>> 4096k	73.0 MB/s
>> 8192k	74.3 MB/s
>> 16384k	74.5 MB/s
>> 
>> It shows that >=128k client side readahead is enough for single disk
>> case :) As for RAID configurations, I guess big server side readahead
>> should be enough.

Trond> There are lots of people who would like to use NFS on their
Trond> company WAN, where you typically have high bandwidths (up to
Trond> 10GigE), but often a high latency too (due to geographical
Trond> dispersion).  My ping latency from here to a typical server in
Trond> NetApp's Bangalore office is ~ 312ms. I read your test results
Trond> with 10ms delays, but have you tested with higher than that?

If you have that high a latency, the low level TCP protocol is going
to kill your performance before you get to the NFS level.  You really
need to open up the TCP window size at that point.  And it only gets
worse as the bandwidth goes up too.  

There's no good solution, because while you can get good throughput at
points, latency is going to suffer no matter what.

John

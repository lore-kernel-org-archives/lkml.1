Return-Path: <linux-kernel-owner+w=401wt.eu-S1030493AbXBTWTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493AbXBTWTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030499AbXBTWTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:19:39 -0500
Received: from palrel12.hp.com ([156.153.255.237]:55195 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030493AbXBTWTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:19:38 -0500
X-Greylist: delayed 1054 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 17:19:38 EST
Message-ID: <45DB6FD8.4050106@hp.com>
Date: Tue, 20 Feb 2007 14:02:00 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking
 UDPv4 recvfrom() taking 4usec @ 3GHz?
References: <20070219231447.GA4400@outpost.ds9a.nl>	<p73d545drx6.fsf@bingen.suse.de>	<20070220162714.GA3245@outpost.ds9a.nl>	<20070220164124.GA24930@2ka.mipt.ru>	<20070220184242.GA30077@filer.fsl.cs.sunysb.edu>	<20070220184859.GA1949@2ka.mipt.ru> <20070220193319.GA8800@outpost.ds9a.nl>
In-Reply-To: <20070220193319.GA8800@outpost.ds9a.nl>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I measure a huge slope, however. Starting at 1usec for back-to-back system
> calls, it rises to 2usec after interleaving calls with a count to 20
> million.
> 
> 4usec is hit after 110 million.
> 
> The graph, with semi-scientific error-bars is on
> http://ds9a.nl/tmp/recvfrom-usec-vs-wait.png
> 
> The code to generate it is on:
> http://ds9a.nl/tmp/recvtimings.c
> 
> I'm investigating this further for other system calls. It might be that my
> measurements are off, but it appears even a slight delay between calls
> incurs a large penalty.

The slope appears to be flattening-out the farther out to the right it 
goes.  Perhaps that is the length of time it takes to take all the 
requisite cache misses.

Some judicious use of HW perf counters might be in order via say papi or 
pfmon.  Otherwise, you could try a test where you don't delay, but do 
try to blow-out the cache(s) between recvfrom() calls.  If the delay 
there starts to match the delay as you go out to the right on the graph 
it would suggest that it is indeed cache effects.

rick jones

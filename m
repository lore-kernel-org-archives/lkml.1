Return-Path: <linux-kernel-owner+w=401wt.eu-S1762401AbYAKR4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401AbYAKR4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbYAKR4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:56:46 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30432 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759882AbYAKR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:56:45 -0500
Message-ID: <4787ADDA.7090602@hp.com>
Date: Fri, 11 Jan 2008 09:56:42 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Netperf TCP_RR(loopback) 10% regression in 2.6.24-rc6,	comparing
 with 2.6.22
References: <1199871330.3298.132.camel@ymzhang> <1200043854.3265.24.camel@ymzhang>
In-Reply-To: <1200043854.3265.24.camel@ymzhang>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>The test command is:
>>#sudo taskset -c 7 ./netserver
>>#sudo taskset -c 0 ./netperf -t TCP_RR -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -r 1,1

A couple of comments/questions on the command lines:

*) netperf/netserver support CPU affinity within themselves with the 
global -T option to netperf.  Is the result with taskset much different? 
   The equivalent to the above would be to run netperf with:

./netperf -T 0,7 ...

The one possibly salient difference between the two is that when done 
within netperf, the initial process creation will take place wherever 
the scheduler wants it.

*) The -i option to set the confidence iteration count will silently cap 
the max at 30.

happy benchmarking,

rick jones

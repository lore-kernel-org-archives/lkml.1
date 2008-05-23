Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbYEWAR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbYEWAR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYEWARr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:17:47 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:43011 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbYEWARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:17:46 -0400
Message-ID: <48360D21.9060102@nortel.com>
Date: Thu, 22 May 2008 18:17:37 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Li, Tong N" <tong.n.li@intel.com>, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu, pj@sgi.com
Subject: Re: fair group scheduler not so fair?
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins> <4835D14B.20904@nortel.com> <1211486868.6463.134.camel@lappy.programming.kicks-ass.net> <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com> <1211490819.6463.172.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1211490819.6463.172.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2008 00:17:42.0111 (UTC) FILETIME=[6A9A46F0:01C8BC6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> Given the following:
> 
>       root
>      / | \
>    _A_ 1  2
>   /| |\
>  3 4 5 B
>       / \
>      6   7
> 
>      CPU0            CPU1
>      root            root
>      /  \            /  \
>     A    1          A    2
>    / \             / \
>   4   B           3   5
>      / \
>     6   7

How do you move specific groups to different cpus.  Is this simply using 
cpusets?

> 
> Numerical examples given the above scenario, assuming every body's
> weight is 1024:

>  s_(0,A) = s_(1,A) = 512

Just to make sure I understand what's going on...this is half of 1024 
because it shows up on both cpus?

>  s_(0,B) = 1024, s_(1,B) = 0

This gets the full 1024 because it's only on one cpu.

>  rw_(0,A) = rw(1,A) = 2048
>  rw_(0,B) = 2048, rw_(1,B) = 0

How do we get 2048?  Shouldn't this be 1024?

>  h_load_(0,A) = h_load_(1,A) = 512
>  h_load_(0,B) = 256, h_load(1,B) = 0

At this point the numbers make sense, but I'm not sure how the formula 
for h_load_ works given that I'm not sure what's going on for rw_.

Chris

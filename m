Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbXJDMda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbXJDMda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbXJDMdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:33:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43076 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbXJDMdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:33:22 -0400
Message-ID: <4704DD88.8030804@cn.fujitsu.com>
Date: Thu, 04 Oct 2007 21:33:12 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <200710031346.l93DkWbE028800@harpo.it.uu.se>	<20071003232509.929160f1.kamezawa.hiroyu@jp.fujitsu.com>	<4704D4DE.8010805@cn.fujitsu.com> <20071004211746.3071b717.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071004211746.3071b717.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote::
> On Thu, 04 Oct 2007 20:56:14 +0900
> Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> 
>> 	stack.ss_sp = addr + pagesize;
>> 	stack.ss_flags = 0;
>> 	stack.ss_size = pagesize;
> Here is bad. 
> stack,ss_sp = addr;
> stack.ss_flags = 0;
> stack.ss_size = pagesize * 2;
[What the test code want to do]
addr+pagesize*2 - addr+pagesize	 -> sigaltstack
addr+pagesize	- addr		 -> protected region
The code want to catch overflow when esp enter the protected region.

But it failed ...
> 
> cheers.
> -Kame
> 
> 
> 


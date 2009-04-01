Return-Path: <linux-kernel-owner+w=401wt.eu-S1765016AbZDAPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765016AbZDAPL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbZDAPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:11:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58291 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbZDAPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:11:16 -0400
Message-ID: <fe5dec67977261684809e4fb7a63dbc1.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090401144252.GE4210@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090401144252.GE4210@balbir.in.ibm.com>
Date: Thu, 2 Apr 2009 00:11:11 +0900 (JST)
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> ==brief test result==
>> On 2CPU/1.6GB bytes machine. create group A and B
>>   A.  soft limit=300M
>>   B.  no soft limit
>>
>>   Run a malloc() program on B and allcoate 1G of memory. The program
>> just
>>   sleeps after allocating memory and no memory refernce after it.
>>   Run make -j 6 and compile the kernel.
>>
>>   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
>>   When vm.swappiness = 10  => 1MB of memory are swapped out from B
>>
>>   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
>>
>
> I did some brief functionality tests and the results are far better
> than the previous versions of the patch. Both my v7 (with some minor
> changes) and this patchset seem to do well functionally. Time to do
> some more exhaustive tests. Any results from your end?
>
Grad to hear that.

Seems good result under several simple tests after fixing
inactive_anon_is_low(). But needed some fixes for corner cases,
add hook to uncharge, hook to cpu hotplug, etc....and making codes
slim, tuning parameters to make more sense. (or adding comments.)

I wonder whether it's convenient to post v2 before new mmotm.
(mmotm includes some fixes around memcg/vmscan.)
I'll continue test (hopefully more complicated cases on big machine.)

Anyway, I often update patch to v5 or more before posting final ones ;)

Thanks,
-Kame




Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZG1KEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZG1KEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZG1KEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:04:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33483 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZG1KEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:04:11 -0400
Message-ID: <2c1ca41fbc03aeab347be61920e222b1.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <877hxti405.fsf@basil.nowhere.org>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
    <20090728161813.f2fefd29.kamezawa.hiroyu@jp.fujitsu.com>
    <877hxti405.fsf@basil.nowhere.org>
Date: Tue, 28 Jul 2009 19:04:07 +0900 (JST)
Subject: Re: [BUGFIX] set_mempolicy(MPOL_INTERLEAV) N_HIGH_MEMORY aware
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Miao Xie" <miaox@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Paul Menage" <menage@google.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "David Rientjes" <rientjes@google.com>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>,
       "linux-mm" <linux-mm@kvack.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>
>> tested on x86-64/fake NUMA and ia64/NUMA.
>> (That ia64 is a host which orignal bug report used.)
>>
>> Maybe this is bigger patch than expected, but NODEMASK_ALLOC() will be a
>> way
>> to go, anyway. (even if CPUMASK_ALLOC is not used anyware yet..)
>> Kosaki tested this on ia64 NUMA. thanks.
>
> Note that low/high memory support in NUMA policy is only partial
> anyways, e.g. the VMA based policy only supports a single zone. That
> was by design choice and because NUMA has a lot of issues on 32bit due
> to the limited address space and is not widely used.
>
> So small fixes are ok but I wouldn't go to large effort to fix NUMA
> policy on 32bit.
>
ya, maybe you mention to something related to policy_zone.
It's checked only in bind code now. (from before 2.6.30..)
The bug was accessing NODE_DATA(nid), which is NULL.
(All possible node doesn't have pgdat)

Thanks,
-Kame



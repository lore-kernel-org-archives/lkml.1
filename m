Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZJAADI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZJAADI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZJAADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:03:07 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58451 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZJAADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:03:06 -0400
Message-id: <isapiwc.34aac0fd.3bb4.4ac3f042.11536.9@mail.jp.nec.com>
In-Reply-To: <20091001083133.429f373b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
 <20090930190943.8f19c48b.kamezawa.hiroyu@jp.fujitsu.com>
 <20091001083133.429f373b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 1 Oct 2009 08:56:50 +0900
From: nishimura@mxp.nes.nec.co.jp
Subject: Re: [RFC][PATCH 1/2] percpu array counter like vmstat
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 30 Sep 2009 19:09:43 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> +int array_counter_init(struct array_counter *ac, int size)
>> +{
>> +	ac->v.elements = size;
>> +	ac->v.counters = alloc_percpu(s8);
> This is a bug, of course...
Yes, I was confused at that point and about to pointing it out :)

> should be
> ac->v.counters = __alloc_percpu(size, __alignof__(char));
> 
__alloc_pecpu(size * sizeof(s8), __alignof__(s8)) would be better ?
There is no actual difference, though.


Thanks,
Daisuke Nishimura.

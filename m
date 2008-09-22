Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYIVOue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYIVOue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYIVOu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:50:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60682 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYIVOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:50:25 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <19184326.1222095015978.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 22 Sep 2008 23:50:15 +0900 (JST)
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Re: [PATCH 4/13] memcg: force_empty moving account
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1222093420.16700.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <1222093420.16700.2.camel@lappy.programming.kicks-ass.net>
 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922200025.49ea6d70.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>> +			spin_lock_irqsave(&mz->lru_lock, flags);
>> +		} else {
>> +			unlock_page(page);
>> +			put_page(page);
>> +		}
>> +		if (atomic_read(&mem->css.cgroup->count) > 0)
>> +			break;
>>  	}
>>  	spin_unlock_irqrestore(&mz->lru_lock, flags);
>
>do _NOT_ use yield() ever! unless you know what you're doing, and
>probably not even then.
>
>NAK!
Hmm, sorry. cond_resched() is ok ?

Thanks,
-Kame

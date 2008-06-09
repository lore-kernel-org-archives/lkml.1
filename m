Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYFIMDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYFIMDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYFIMDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:03:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53679 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYFIMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:03:35 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <29463997.1213012967896.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 9 Jun 2008 21:02:47 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, menage@google.com,
       xemul@openvz.org, yamamoto@valinux.co.jp
In-Reply-To: <484D07F0.6020407@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <484D07F0.6020407@linux.vnet.ibm.com>
 <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com> <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com> <484CFC7F.20300@linux.vnet.ibm.com> <20080609192002.b04354c4.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
way, breaks limit semantics.
>>>
>> Not easy to use in my point of view. Can we use 'share' in proper way 
>> on no-swap machine ?
>> 
>
>Not sure I understand your question. Share represents the share of available
>resources.
>

If no swap, you cannot reclaim anonymous pages and shared memory.
Then, the kernel has to abandon any kinds of auto-balancing somewhere.
(just an example. Things will be more complicated when we consinder
 mlocked pages and swap-resource-controller.)


>> yield() after callback() means that res_counter's state will be
>> far different from the state after callback.
>> So, we have to yield before call back and check res_coutner sooner.
>> 
>
>But does yield() get us any guarantees of seeing the state change?
>
Hmm, myabe my explanation is bad.

in following sequence
   1.callback()
   2.yield()
   3.check usage again
Elapsed time between 1->3 is big.

in following
   1.yield()
   2.callback()
   3.check usage again
Elapsed time between 2->3 is small.

There is an option to implement "changing limit grarually"

Thanks,
-Kame










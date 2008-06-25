Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYFYGLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYFYGLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYFYGLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:11:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33020 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYFYGLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:11:13 -0400
Date: Wed, 25 Jun 2008 15:08:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>
In-Reply-To: <28c262360806242259k3ac308c4n7cee29b72456e95b@mail.gmail.com>
References: <20080624092824.4f0440ca@bree.surriel.com> <28c262360806242259k3ac308c4n7cee29b72456e95b@mail.gmail.com>
Message-Id: <20080625150141.D845.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim-san,

> >> So, if priority==0, We should try to reclaim all page for prevent OOM.
> >
> > You are absolutely right.  Good catch.
> 
> I have a concern about application latency.
> If lru list have many pages, it take a very long time to scan pages.
> More system have many ram, More many time to scan pages.

No problem.

priority==0 indicate emergency.
it doesn't happend on typical workload.


> Of course I know this is trade-off between memory efficiency VS latency.
> But In embedded, some application think latency is more important
> thing than memory efficiency.
> We need some mechanism to cut off scanning time.
> 
> I think Takenori Nagano's "memory reclaim more efficiently patch" is
> proper to reduce application latency in this case If we modify some
> code.

I think this is off-topic.

but Yes.
both my page reclaim throttle and nagano-san's patch provide 
reclaim cut off mechanism.


and more off-topic,
nagano-san's patch improve only priority==12.
So, typical embedded doesn't improve so big because 
embedded system does't have so large memory.




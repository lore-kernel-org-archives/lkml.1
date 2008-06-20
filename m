Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYFTGpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYFTGpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbYFTGpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:45:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50985 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYFTGpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:45:03 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <33021525.1213944281400.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 20 Jun 2008 15:44:41 +0900 (JST)
To: Paul Menage <menage@google.com>
Subject: Re: Re: [PATCH 2/2] memcg: reduce usage at change limit
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, balbir@linux.vnet.ibm.com,
       xemul@openvz.org, lizf@cn.fujitsu.com, yamamoto@valinux.co.jp,
       nishimura@mxp.nes.nec.co.jp, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <6599ad830806192216m41027e09r7605b9f85c283ae8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <6599ad830806192216m41027e09r7605b9f85c283ae8@mail.gmail.com>
 <20080617123144.ce5a74fa.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080617123604.c8cb1bd5.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>Date: 	Thu, 19 Jun 2008 22:16:07 -0700
>From: "Paul Menage" <menage@google.com>
>> Reduce the usage of res_counter at the change of limit.
>>
>> Changelog v4 -> v5.
>>  - moved "feedback" alogrithm from res_counter to memcg.
>
>FWIW, I really thought it was much better having it in the generic res_counte
r.
>
Hmm ;)

Balbir and Pavel pointed out that

the resouce which can shrink if necessary is
 - user's memory usage
 - kernel memory (slab) if it can. (not implemented)

And there are other users of res_counter which cannot shrink.
(I think -EBUSY should be returned)

Now, my idea is
- implement "feedback" in memcg because it is an only user
- fix res_counter to return -EBUSY

I think we can revisit later "implement generic feedback in res_counter".
And such kind of implementation change will not big.(I think)

Another point is I don't want to make res_counter big. To support
generic ops in res_counter (handle limit, hierarchy, high-low watermark...)
res_counter must be bigger that it is. And most of users of res_counder doesn'
t want such ops.

To be honest, both way is okay to me. But I'd like to start from not-invasive
one.

Thanks,
-Kame


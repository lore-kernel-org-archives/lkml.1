Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYKFMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYKFMrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYKFMr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:47:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40773 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYKFMr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:47:27 -0500
Message-ID: <30704.10.75.179.61.1225975644.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0811061151130.26541@blonde.site>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com><49129493.9070103@linux.vnet.ibm.com>
    <20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
    <Pine.LNX.4.64.0811061151130.26541@blonde.site>
Date: Thu, 6 Nov 2008 21:47:24 +0900 (JST)
Subject: Re: [RFC][PATCH 7/6] memcg: add atribute (for change bahavior 
     ofrmdir)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Hugh Dickins" <hugh@veritas.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins said:
> On Thu, 6 Nov 2008, KAMEZAWA Hiroyuki wrote:
>> On Thu, 06 Nov 2008 12:24:11 +0530
>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> > KAMEZAWA Hiroyuki wrote:
>> > >
>> > > 1. change force_empty to do move account rather than forget all
>> >
>> > I would like this to be selectable, please. We don't want to break
>> behaviour and
>> > not everyone would like to pay the cost of movement.
>>
>> How about a patch like this ? I'd like to move this as [2/7], if
>> possible.
>> It obviously needs painful rework. If I found it difficult, schedule
>> this as [7/7].
>>
>> BTW, cost of movement itself is not far from cost for force_empty.
>>
>> If you can't find why "forget" is bad, please consider one more day.
>
> My recollection from a year ago is that force_empty totally violated
> the rules established elsewhere, making a nonsense of it all: once a
> force_empty had been done, you couldn't really be sure of anything
> (perhaps it deserved a Taint flag).
>
yes. that was terrible. (but necessary to do so because we accounted
pages not on LRU or some other reason.)

> Without studying your proposals at all, I do believe you've a good
> chance of creating a sensible and consistent force_empty by moving
> account, and abandoning the old "forget all" approach completely.
>

yes. I'm very encouraged. thanks!
After patch [1/6]
  -> move all at force empty
After this
  -> move all or free (not forget) all.

-Kame



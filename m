Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0ASBtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0ASBtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0ASBto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:49:44 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37157 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0ASBtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=igwcMpSPE5wxF8VX4x32Ds2drojcml6AsSNSJ+sn/rexjdCCjw2kWm6gtESt7I0460
         F3FycNPHLzBwd2qgMXN2J+gXFlYDrGfidGfhVJkhFqejtOB/ADTcADGuMAg8O06EmHSb
         I5IQMB9w59FuP7Adzhm2WH2PB9Sm13FfvgI14=
MIME-Version: 1.0
In-Reply-To: <20100119102208.59a16397.nishimura@mxp.nes.nec.co.jp>
References: <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100107083440.GS3059@balbir.in.ibm.com>
	 <20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100107092736.GW3059@balbir.in.ibm.com>
	 <20100108084727.429c40fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <661de9471001171130p2b0ac061he6f3dab9ef46fd06@mail.gmail.com>
	 <20100118094920.151e1370.nishimura@mxp.nes.nec.co.jp>
	 <4B541B44.3090407@linux.vnet.ibm.com>
	 <20100119102208.59a16397.nishimura@mxp.nes.nec.co.jp>
Date: Tue, 19 Jan 2010 07:19:42 +0530
X-Google-Sender-Auth: 827f79b87f9a8da3
Message-ID: <661de9471001181749y2fe22a15j1c01c94aa1838e99@mail.gmail.com>
Subject: Re: [RFC] Shared page accounting for memory cgroup
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 6:52 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
[snip]
>> Correct, file cache is almost always considered shared, so it has
>>
>> 1. non-private or shared usage of 10MB
>> 2. 10 MB of file cache
>>
>> > I don't think "non private usage" is appropriate to this value.
>> > Why don't you just show "sum_of_each_process_rss" ? I think it would be easier
>> > to understand for users.
>>
>> Here is my concern
>>
>> 1. The gap between looking at memcg stat and sum of all RSS is way
>> higher in user space
>> 2. Summing up all rss without walking the tasks atomically can and
>> will lead to consistency issues. Data can be stale as long as it
>> represents a consistent snapshot of data
>>
>> We need to differentiate between
>>
>> 1. Data snapshot (taken at a time, but valid at that point)
>> 2. Data taken from different sources that does not form a uniform
>> snapshot, because the timestamping of the each of the collected data
>> items is different
>>
> Hmm, I'm sorry I can't understand why you need "difference".
> IOW, what can users or middlewares know by the value in the above case
> (0MB in 01 and 10MB in 02)? I've read this thread, but I can't understande about
> this point... Why can this value mean some of the groups are "heavy" ?
>

Consider a default cgroup that is not root and assume all applications
move there initially. Now with a lot of shared memory,
the default cgroup will be the first one to page in a lot of the
memory and its usage will be very high. Without the concept of
showing how much is non-private, how does one decide if the default
cgroup is using a lot of memory or sharing it? How
do we decide on limits of a cgroup without knowing its actual usage -
PSS equivalent for a region of memory for a task.

Balbir

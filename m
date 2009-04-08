Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbZDHHpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbZDHHpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZDHHpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:45:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:40503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZDHHpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x4Hj/NX1G61xhxksq2ODe7lEYXr+sFEExo6EoVPjcxzUqCqfJXpK4OHbiybpZcffg6
         VfwFHX2eI4kXywXCvlGx9CXQyTdPyAS9PzxnSiZCkQpYs/4zAohvW/Ybx6ADOQER2Q3H
         1aOS16J4LPoss9e8jNcjjzHrQFfT1DwhFbpVE=
MIME-Version: 1.0
In-Reply-To: <20090408163440.4442dc3c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090407063722.GQ7082@balbir.in.ibm.com>
	 <20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090408052904.GY7082@balbir.in.ibm.com>
	 <20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090408070401.GC7082@balbir.in.ibm.com>
	 <20090408160733.4813cb8d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090408071115.GD7082@balbir.in.ibm.com>
	 <20090408161824.26f47077.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0904080031y4406c001n584725b87024755@mail.gmail.com>
	 <20090408163440.4442dc3c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 8 Apr 2009 13:15:01 +0530
Message-ID: <344eb09a0904080045s94c792dmc2250aaf39c09222@mail.gmail.com>
Subject: Re: [RFI] Shared accounting for memory resource controller
From: Bharata B Rao <bharata.rao@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 1:04 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 8 Apr 2009 13:01:15 +0530
> Bharata B Rao <bharata.rao@gmail.com> wrote:
>
>> On Wed, Apr 8, 2009 at 12:48 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >
>> > On Wed, 8 Apr 2009 12:41:15 +0530
>> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> > > 3. Using the above, we can then try to (using an algorithm you
>> > > proposed), try to do some work for figuring out the shared percentage.
>> > >
>> > This is the point. At last. Why "# of shared pages" is important ?
>> >
>> > I wonder it's better to add new stat file as memory.cacheinfo which helps
>> > following kind of commands.
>> >
>> >  #cacheinfo /cgroups/memory/group01/
>> >       /usr/lib/libc.so.1     30pages
>> >       /var/log/messages      1 pages
>> >       /tmp/xxxxxx            20 pages
>>
>> Can I suggest that we don't add new files for additional stats and try
>> as far as possible to include them in <controller>.stat file. Please
>> note that we have APIs in libcgroup library which can return
>> statistics from controllers associated with a cgroup and these APIs
>> assume that stats are part of <controller>.stat file.
>>
> Hmm ? Is there generic assumption as all cgroup has "stat" file ?

No. But I would think if any controller has any stats to export, it
would do so via <controller>.stat file.

> And libcgroup cause bug if the new entry is added to stat file ?

No. It can cope with new entries being added to stat file as long as
they appear as (name, value) pairs.

> (IOW, libcgroup can't ignore new entry added ?)

It won't ignore, but can read the new stat.

Regards,
Bharata.

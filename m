Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZE0BGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZE0BGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZE0BGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:06:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZE0BGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:06:10 -0400
Message-ID: <4A1C9253.3060108@cn.fujitsu.com>
Date: Wed, 27 May 2009 09:07:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at 
 mount/remount
References: <4A16153C.2080004@cn.fujitsu.com>	 <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830905261506x480f2167naf1034177bbc7036@mail.gmail.com>
In-Reply-To: <6599ad830905261506x480f2167naf1034177bbc7036@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, May 22, 2009 at 1:25 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
>> I think it's just for backward-compatibility of cpuset.
>> (I don't like the option at all.)
> 
> Yes, exposing the "noprefix" option externally was one of the mistakes
> I made when developing cgroups.
> 
> It seems to me really unlikely that anyone is using "noprefix" for

And "noprefix" is not documented in cgroups.txt, so I guess not
many people know this option. Even libcgroup doesn't handle it.

> anything other than implicitly when mounting the "cpuset" filesystem.
> So I'd be inclined to just forbid it if we're mounting more than just
> the cpuset subsystem. A bit of a nasty abstraction violation, but it
> makes more sense overall. The only problem is that someone *might* be
> using it - do we have any way to determine how, and how big do they
> have to be before we care?
> 

I think we can never know..

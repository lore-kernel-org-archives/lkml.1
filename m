Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZGNBFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZGNBFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZGNBFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:05:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33773 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZGNBFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:05:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Jul 2009 10:03:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Vladislav D. Buzov" <vbuzov@embeddedalley.com>
Cc: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
Message-Id: <20090714100320.454ca54b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A5BD8C5.1060902@embeddedalley.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
	<1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
	<1246998310-16764-2-git-send-email-vbuzov@embeddedalley.com>
	<20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com>
	<4A5BD8C5.1060902@embeddedalley.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 18:00:53 -0700
"Vladislav D. Buzov" <vbuzov@embeddedalley.com> wrote:

> Paul Menage wrote:
> > On Tue, Jul 7, 2009 at 5:56 PM, KAMEZAWA
> > Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >   
> >> I know people likes to wait for file descriptor to get notification in these days.
> >> Can't we have "event" file descriptor in cgroup layer and make it reusable for
> >> other purposes ?
> >>     
> >
> > I agree - rather than having to add a separate "wait for value to
> > cross X threshold" file for each numeric usage value that people might
> > be concerned about, it would be better to have a generic way to do it
> > for any file. Given that this is a userspace API, it would be better
> > to work out at least the generic API first, even if the initial
> > implementation isn't generic.
> >  "OOM"
> >   
> We all agree on that. Our original intention was to create the memory
> limit notification capability, not a generic mechanism for the cgroup
> events. So, we started out with something that fits the current model.
> 
> > - independent thresholds for different waiters
> >   
> The threshold is one of the Memory Controller cgroup attributes, as well
> as memory usage limit. It is not a user task attribute and should not be
> controlled by user tasks. It's administrator or some control task job to
> set memory usage parameters within the cgroup. Once the threshold is
> reached, all tasks within the cgroup should be notified and do their
> best to free the memory.
> 
About this, I'll add following file.

  memory.reduce_usage  --- try to reduce memory usage to be smaller than...?

if your notifier goes in. Maybe good for dropping file caches etc.. for your notifer
use case.

Thanks,
-Kame






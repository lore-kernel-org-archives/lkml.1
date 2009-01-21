Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZAUDIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZAUDIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZAUDIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:08:09 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:48552 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754191AbZAUDIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:08:07 -0500
Date: Wed, 21 Jan 2009 12:05:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, Trilok Soni <soni.trilok@gmail.com>,
       Arve Hj?nnev?g <arve@android.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Brian Swetland <swetland@google.com>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090121030504.GA14094@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Greg KH <greg@kroah.com>, Trilok Soni <soni.trilok@gmail.com>,
	Arve Hj?nnev?g <arve@android.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	Brian Swetland <swetland@google.com>, arve@google.com,
	San Mehat <san@android.com>, Robert Love <rlove@google.com>,
	linux-kernel@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	ext Juha Yrj?l? <juha.yrjola@solidboot.com>,
	viktor.rosendahl@nokia.com
References: <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com> <20090116152338.GB9357@kroah.com> <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 11:50:48AM +0900, KOSAKI Motohiro wrote:
> I should rewrite memory notification patchset from scratch.
> the new version will construct on memcg infrastrcture.
> 
> Why?
> 
> last year, I received many feedback from lkml folks and my article reader.
> (I monthly write kernel patch introduction article to japanese web
>  magazine and receive some feedback periodically)
> 
> I learned many people want flexibility notification.
> (per workload, per user, et al)
> eg. nokia lowmem driver have exception process defined by uid.
> 
> at top of last year, I thought memcg don't provide good infrastructure.
> the first version memcg is just pretty funny joke. if its config turn on,
> memory workload performance decrease ~30% although the user don't use 
> memcg at runtime. then nobody use it.
> but recently, KAMEZAWA hiroyuki (and Li zefan, Daisuke Nishimura et al)
> dramatically improvement memcg performance. 
> now, memcg overhead become less than 1%. 
> 
> Then, I think any memory accounting activity should use this infrastructure.
> That's my homework.
> 
Building on top of the memory cgroup makes sense given that it has a
lot more knowledge of the actual state in different contexts compared to
something like security_vm_enough_memory()/__vm_enough_memory().

Despite that, a notification layer on top of cgroups in general might be
worth thinking about, particularly since each controller may want to use
notifications for different things. It is conceivable that people will
also want different types of notifications from the memory controller
beyond a simple lowmem notifier.

The LSM lowmem module itself used multiple notification levels to tune
application behaviour for instance, though obviously this is something
that is highly workload dependent.

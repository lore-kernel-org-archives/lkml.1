Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbZAUCvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbZAUCvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 21:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZAUCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 21:51:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37324 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZAUCvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 21:51:36 -0500
Date: Wed, 21 Jan 2009 11:50:48 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Greg KH <greg@kroah.com>
Subject: Re: lowmemory android driver not needed?
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Mundt <lethal@linux-sh.org>,
       Trilok Soni <soni.trilok@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
In-Reply-To: <20090116152338.GB9357@kroah.com>
References: <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com> <20090116152338.GB9357@kroah.com>
Message-Id: <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 16, 2009 at 08:16:51PM +0900, KOSAKI Motohiro wrote:
> > 
> > As far as I know, embedded guys strong want to lowmem notification mecanism.
> 
> I think the big server guys also want the same thing :)

Yeah! I know, because my company is definitry big server vendor :)


> > At least, I and my mem_notify receive multiple contact from embedded
> > and JavaVM developer.
> >  (include sun javavm engineer)
> > 
> > In ideal, I think linux MM should care this requirement directly.
> 
> I agree.
> 
> > LSM and driver notifier is easy breakable because these component
> > deeply depend on MM.
> 
> Agreed.
> 
> > (eg, I developed /dev/mem_notify patch last year. but this patch don't
> > work on 2.6.28 because split-lru patch series totally changed MM
> > reclaim processing.)
> > 
> > Unfortunately, we don't have any consensus of memory notification requirement.
> > various people have various requirement. so, if I can discuss it and
> > we get consensus, I'm glad.
> 
> Care to work on your mem_notify patch again and bring it up to date?
> That would be a good place to start working from, right?

Unfortunately No ;)

I should rewrite memory notification patchset from scratch.
the new version will construct on memcg infrastrcture.

Why?

last year, I received many feedback from lkml folks and my article reader.
(I monthly write kernel patch introduction article to japanese web
 magazine and receive some feedback periodically)

I learned many people want flexibility notification.
(per workload, per user, et al)
eg. nokia lowmem driver have exception process defined by uid.

at top of last year, I thought memcg don't provide good infrastructure.
the first version memcg is just pretty funny joke. if its config turn on,
memory workload performance decrease ~30% although the user don't use 
memcg at runtime. then nobody use it.
but recently, KAMEZAWA hiroyuki (and Li zefan, Daisuke Nishimura et al)
dramatically improvement memcg performance. 
now, memcg overhead become less than 1%. 

Then, I think any memory accounting activity should use this infrastructure.
That's my homework.




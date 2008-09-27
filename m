Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYI0OHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYI0OHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 10:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYI0OHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 10:07:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbYI0OHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 10:07:39 -0400
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
	system (intended for antivirus scanning and file indexers)
From: Eric Paris <eparis@redhat.com>
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk, hch@infradead.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, peterz@infradead.org,
       Jonathan.Press@ca.com, riel@redhat.com
In-Reply-To: <alpine.DEB.1.10.0809262259290.4229@asgard.lang.hm>
References: <1222463220.2872.193.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0809262259290.4229@asgard.lang.hm>
Content-Type: text/plain
Date: Sat, 27 Sep 2008 10:04:54 -0400
Message-Id: <1222524294.2872.252.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 23:05 -0700, david@lang.hm wrote:
> On Fri, 26 Sep 2008, Eric Paris wrote:
> 
> > fanotify has 7 event types and only sends events for S_ISREG() files.
> > The event types are OPEN, READ, WRITE, CLOSE_WRITE, CLOSE_NOWRITE,
> > OPEN_ACCESS, and READ_ACCESS.  Events OPEN_ACCESS and READ_ACCESS
> > require that the listener return some sort of allow/deny/more_time
> > response as the original process blocks until it gets an event (or times
> > out.)  listeners may register a group which will get notifications about
> > any combination of these events.  Antivirus scanners will likely want
> > OPEN_ACCESS and READ_ACCESS while file indexers would likely use the
> > non-ACCESS form of these events.
> 
> sending a message out for every READ/WRITE seems like it will generate a 
> LOT of messages, and very few will be ones that anyone cares about.
> 
> one of the nice things about the TALPA approach was that there was an 
> ability to notify only on a change of state (i.e. when a file that had 
> been scanned was changed)
> 
> this could do a similar thing, but I think it would be a much more 
> expensive process to do it all in userspace.

See the fastpath patch and explaination.  Doesn't help for writes...


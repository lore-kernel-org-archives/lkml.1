Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZDNEP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZDNEP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZDNEPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:15:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:50183 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZDNEPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xOzaTShkiDU8PVe3lbFtOHZm+r8ybLON4TvqdFn1eq32aiE3bODr+W12+hkV8R7rV2
         84oouxWL4oTofmxvaGyYGwfcMLGjlVpA/dzQYPSCciM48+ei/9Z0HNIIuygV4DQUSqYz
         tOkl2PnAO5Gy2RheIlgptPnPV3C+cjKPzk7QE=
Subject: Re: [PATCH] blktrace: move trace/ dir to /sys/block/sda/
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090413201155.GA17450@elte.hu>
References: <49E31931.5000506@cn.fujitsu.com>
	 <20090413180054.GZ5178@kernel.dk>  <20090413201155.GA17450@elte.hu>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 23:15:04 -0500
Message-Id: <1239682504.7011.46.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 22:11 +0200, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Apr 13 2009, Li Zefan wrote:
> > > Impact: allow ftrace-plugin blktrace to trace device-mapper devices
> > > 
> > > blktrace can't trace a single partition, so it makes no sense to
> > > have one trace/ dir in each /sys/block/sda/sdaX. Move it to
> > > /sys/block/sda/.
> > > 
> > > Thus we fix an issue reported by Ted, that ftrace-plugin 
> > > blktrace can't be used to trace device-mapper devices.
> > 
> > Perhaps I never committed that patch, but it would be trivial to 
> > do partition based blktrace tracing. It's also quite useful. So 
> > please don't go changing things to make that harder to support, it 
> > would be nicer to just add the (small) bits to support 
> > per-partition tracing. It's basically just a start/stop sector 
> > range, while some events are per-device and should just be 
> > included always.
> 
> btw., per tracepoint filters could be used for that. That would 
> allow multiple partitions to be traced at once.
> 
> blktrace user-space could make use of sector range filters straight 
> away [ hm, Tom - do we have the <= comparison operator already, or 
> is that still WIP? ] - but i think it's better to do this in a more 

The new comparison operators aren't there yet, but will be part of the
new parser, which I'll be getting back to this week.

Tom

> integrated way: via the sysfs API, via /sys/block/sda/sda2/trace/.
> 
> So when a partition's trace entry is activated, it would 
> auto-install a specific filter expression for sda, with the sector 
> range of that partition. Or something like that. How does this 
> sound?
> 
> 	Ingo


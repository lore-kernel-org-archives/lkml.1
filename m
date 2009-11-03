Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZKCVws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZKCVws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZKCVws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:52:48 -0500
Received: from kanga.kvack.org ([205.233.56.17]:49675 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbZKCVwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:52:47 -0500
Date: Tue, 3 Nov 2009 16:52:51 -0500
From: Benjamin LaHaise <bcrl@lhnet.ca>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs directory scaling: rbtree for dirent name lookups
Message-ID: <20091103215251.GS8227@kvack.org>
References: <20091101163130.GA7911@kvack.org> <20091103035058.GA19515@kroah.com> <20091103200155.GQ8227@kvack.org> <m1my338fbi.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1my338fbi.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 01:32:33PM -0800, Eric W. Biederman wrote:
> Are your numbers from your application and are they real world?
> In which case they are interesting, but it would be good if
> we could also have microbenchmark numbers that just measure
> the sysfs costs.   If nothing else I am seeing a big startup
> overhead that isn't being subtracted out that makes it hard
> to see the real costs here.

They're application based, so there's a bunch of other overhead included 
that won't show up on a microbenchmark.  Each interface requires a round 
trip between 2 L2TP daemons, so there are lots of syscalls and other cache 
polluting effects that won't show up on a microbenchmark.  One of the L2TP 
daemons is configured not to instantiate any kernel state -- running in 
this mode, it has very little overhead.

The other thing to note is that the costs posted are how long it takes to 
add an additional 5,000 interfaces in the given range, not the total time 
to add say 35,000 interfaces (I didn't feel like waiting that long).

		-ben

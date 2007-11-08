Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbXKHJFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbXKHJFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbXKHJEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:04:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbXKHJEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:04:44 -0500
Date: Thu, 8 Nov 2007 01:04:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
Cc: neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Massive slowdown when re-querying large nfs dir
Message-Id: <20071108010436.e5ad5036.akpm@linux-foundation.org>
In-Reply-To: <200711081044.35699.a1426z@gawab.com>
References: <200711050758.38090.a1426z@gawab.com>
	<200711071236.26780.a1426z@gawab.com>
	<20071107090529.f45626de.akpm@linux-foundation.org>
	<200711081044.35699.a1426z@gawab.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Nov 2007 10:44:35 +0300 Al Boldi <a1426z@gawab.com> wrote:
> Andrew Morton wrote:
> > > > I would suggest getting a 'tcpdump -s0' trace and seeing (with
> > > > wireshark) what is different between the various cases.
> > >
> > > Thanks Neil for looking into this.  Your suggestion has already been
> > > answered in a previous post, where the difference has been attributed to
> > > "ls -l" inducing lookup for the first try, which is fast, and getattr
> > > for later tries, which is super-slow.
> > >
> > > Now it's easy to blame the userland rpc.nfs.V2 server for this, but
> > > what's not clear is how come 2.4.31 handles getattr faster than 2.6.23?
> >
> > We broke 2.6?  It'd be interesting to run the ls in an infinite loop on
> > the client them start poking at the server.  Is the 2.6 server doing
> > physical IO?  Is the 2.6 server consuming more system time?  etc.  A basic
> > `vmstat 1' trace for both 2.4 and 2.6 would be a starting point.
> >
> > Could be that there's some additional latency caused by networking
> > changes, too.  I expect the tcpdump/wireshark/etc traces would have
> > sufficient resolution for us to be able to see that.
> 
> The problem turns out to be "tune2fs -O dir_index".
> Removing that feature resolves the big slowdown.

Doh.  Well worked-out.

> Does 2.4.31 support this feature?

No.  This explains it.

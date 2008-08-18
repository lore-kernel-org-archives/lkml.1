Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYHRXJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYHRXJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 19:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYHRXJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 19:09:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYHRXJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 19:09:32 -0400
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
	to	a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: tvrtko.ursulin@sophos.com, davecb@sun.com, david@lang.hm,
       Adrian Bunk <bunk@kernel.org>, Peter Dolding <oiaohm@gmail.com>,
       rmeijer@xs4all.nl, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       malware-list-bounces@dmesg.printk.net,
       Casey Schaufler <casey@schaufler-ca.com>, capibara@xs4all.nl,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080818224058.GA2311@elf.ucw.cz>
References: <20080818142511.GC8184@mit.edu>
	 <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <20080818224058.GA2311@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 19:07:04 -0400
Message-Id: <1219100824.15566.151.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 00:40 +0200, Pavel Machek wrote:
> Hi!
> 
> > > On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com 
> > wrote:
> > > > Then there is still a question of who allows some binary to declare 
> > itself 
> > > > exempt. If that decision was a mistake, or it gets compromised 
> > security 
> > > > will be off. A very powerful mechanism which must not be easily 
> > > > accessible.  With a good cache your worries go away even without a 
> > scheme 
> > > > like this.
> > > 
> > > I have one word for you --- bittorrent.  If you are downloading a very
> > > large torrent (say approximately a gigabyte), and it contains many
> > > pdf's that are say a few megabytes a piece, and things are coming in
> > > tribbles, having either a indexing scanner or an AV scanner wake up
> > > and rescan the file from scratch each time a tiny piece of the pdf
> > > comes in is going to eat your machine alive....
> > 
> > Huh? I was never advocating re-scan after each modification and I even 
> > explicitly said it does not make sense for AV not only for performance but 
> > because it will be useless most of the time. I thought sending out 
> > modified notification on close makes sense because it is a natural point, 
> > unless someone is trying to subvert which is out of scope. Other
> > have 
> 
> Why do you think non-malicious applications won't write after close /
> keep file open forever?

If you ask this one more time without reading the many times I've
answered these questions I think I'm going to explode.

Permissions checks are done on open/read.  Decisions are invalidated at
mtime update, which INCLUDES mmap after close!  I don't care if you keep
your file open forever, if you wrote to it, we are just going to scan it
next time a process decided to open/read it.  Please stop confusing this
already long and almost pointless thread with implementation details
that have repeatedly been explained.

-Eric


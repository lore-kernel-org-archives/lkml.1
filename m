Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZG2UW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZG2UW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZG2UW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:22:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38315 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbZG2UWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:22:25 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <1248781708.14145.21.camel@localhost.localdomain>
References: <1248466429.3567.82.camel@localhost>
	 <1248781708.14145.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:20:33 -0400
Message-Id: <1248898833.2597.66.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 07:48 -0400, Jon Masters wrote:
> On Fri, 2009-07-24 at 16:13 -0400, Eric Paris wrote:
> 
> > I plan to start sending patches for fanotify in the next week or two.
> 
> Generally, I appreciate your effort (as I'm sure does everyone else).
> 
> I agree with Jamie that it's good to consider extending inotify and also
> that the special socket idea probably won't work for mainline. Also:

The special socket idea was Alan Cox's idea and I haven't heard a usable
alternative.

> 1). Ability to watch only certain mount-points, not just directories. Or
> directories and block on mount operations as Jamie suggested. Or both :)

Show me the user and I'll consider it.

> 2). Add event on mmap perhaps. Future theoretical cloud cuckoo land
> ideas include forcing all mmap operations to be read-only and then
> having the page fault handler fire an event for every write so that the
> anti-malware thing can monitor every single touched page...joke.
> 
> 3). Sounds a lot like netlink could be close enough. Kay and others have
> been playing with in-kernel multiplexing and re-broadcasting of netlink
> events, and I'm pretty sure most of the rest is doable.

Jeez, about the 50th time someone has said netlink.  I need to do the fd
open in the context of the receiving process.  How do I do that with
netlink?  It cannot be done at the netlink msg send side (which is the
context of the original process accessing the file)

> I'm looking forward to updatedb using this.

Well, that's still in the future work, as all updatedb cares about it
rename events, and the kernel does have enough information to send
fanotify events during rename.

> Let's try up-playing the use
> cases outside malware for this stuff.

I'm not playing any spin or bullshit.  I've got HSM users who wants it.
Readahead profiling wants it.  I'm told that wine can properly do
windows style notification with it instead of some hack they have now.
I've also got a need to get people who want to run integrity
checkers/virus scanners to stop binary patching/hacking my kernels.  I'd
say I've found plenty of use cases today even if you don't find them as
sexy as beagle   :)

-Eric


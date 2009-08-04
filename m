Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbZHDQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbZHDQ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZHDQ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:29:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827AbZHDQ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:29:18 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>, "pavel@suse.cz" <pavel@suse.cz>
In-Reply-To: <200908041709.51659.tvrtko.ursulin@sophos.com>
References: <1248466429.3567.82.camel@localhost>
	 <200908041709.51659.tvrtko.ursulin@sophos.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 12:27:48 -0400
Message-Id: <1249403268.2361.21.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 17:09 +0100, Tvrtko Ursulin wrote:
> Hi Eric, all,
> 
> On Friday 24 July 2009 21:13:49 Eric Paris wrote:
> > If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> > must send a response before the 5 second timeout.  If no response is
> > sent before the 5 second timeout the original operation is allowed.  If
> > this happens too many times (10 in a row) the fanotify group is evicted
> > from the kernel and will not get any new events.  Sending a response is
> 
> Would it make more sense to deny on timeouts and then evict? I am thinking it 
> would be more secure with no significant drawbacks. Also for usages like HSM 
> allowing it without data being in place might present wrong content to the 
> user.

I'd be willing to go that route as long as noone else complains.

> > The only other current interface is the ability to ignore events by
> > superblock magic number.  This makes it easy to ignore all events
> > in /proc which can be difficult to accomplish firing FANOTIFY_SET_MARK
> > with ignored_masks over and over as processes are created and destroyed.
> 
> Just to double-check, that would also work for any other filesystem and is 
> controllable from userspace?

Yes you set these in userspace using setsockopt().  It is based on
superblock magic number as found in linux/magic.h.  So one could
exclude, procfs, sysfs, selinuxfs, etc.  It does not provide a way to
say 'this ext3 filesystem but not that ext3 filesystem' as ext3 has a
single magic number.


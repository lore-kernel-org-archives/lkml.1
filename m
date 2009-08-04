Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbZHDQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbZHDQjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932971AbZHDQjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:39:41 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:34635 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbZHDQjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:39:40 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: fanotify - overall design before I start sending patches
Date: Tue, 4 Aug 2009 17:39:33 +0100
User-Agent: KMail/1.9.10
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
References: <1248466429.3567.82.camel@localhost> <200908041709.51659.tvrtko.ursulin@sophos.com> <1249403268.2361.21.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1249403268.2361.21.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Message-Id: <200908041739.33796.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2009 17:39:39,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2009 17:39:39,
	Serialize complete at 04/08/2009 17:39:39
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009 17:27:48 Eric Paris wrote:
> On Tue, 2009-08-04 at 17:09 +0100, Tvrtko Ursulin wrote:
> > Hi Eric, all,
> >
> > On Friday 24 July 2009 21:13:49 Eric Paris wrote:
> > > If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> > > must send a response before the 5 second timeout.  If no response is
> > > sent before the 5 second timeout the original operation is allowed.  If
> > > this happens too many times (10 in a row) the fanotify group is evicted
> > > from the kernel and will not get any new events.  Sending a response is
> >
> > Would it make more sense to deny on timeouts and then evict? I am
> > thinking it would be more secure with no significant drawbacks. Also for
> > usages like HSM allowing it without data being in place might present
> > wrong content to the user.
>
> I'd be willing to go that route as long as noone else complains.

Ok, keep it open then for a while and I guess it is trivial to change this bit 
of behaviour.

> > > The only other current interface is the ability to ignore events by
> > > superblock magic number.  This makes it easy to ignore all events
> > > in /proc which can be difficult to accomplish firing FANOTIFY_SET_MARK
> > > with ignored_masks over and over as processes are created and
> > > destroyed.
> >
> > Just to double-check, that would also work for any other filesystem and
> > is controllable from userspace?
>
> Yes you set these in userspace using setsockopt().  It is based on
> superblock magic number as found in linux/magic.h.  So one could
> exclude, procfs, sysfs, selinuxfs, etc.  It does not provide a way to
> say 'this ext3 filesystem but not that ext3 filesystem' as ext3 has a
> single magic number.

This is probably good enough. Subtree and mount point exclusions would be even 
better (in addition to superblock magic exclusions - I would not get rid of 
them) but I have no idea how realistic this requirement is, or whether it is 
possible to do it more efficiently in kernel space at all.

Tvrtko

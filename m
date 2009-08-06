Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbZHFK3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbZHFK3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZHFK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:29:44 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:63756 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZHFK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:29:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: fanotify - overall design before I start sending patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Douglas Leeder <douglas.leeder@sophos.com>
Cc: Pavel Machek <pavel@ucw.cz>, Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
In-Reply-To: <4A7AAE89.20205@sophos.com>
References: <1248466429.3567.82.camel@localhost>
	 <20090805020534.GB1354@ucw.cz>
	 <200908051746.17903.tvrtko.ursulin@sophos.com>
	 <20090806101059.GD31370@elf.ucw.cz>  <4A7AAE89.20205@sophos.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 12:29:08 +0200
Message-Id: <1249554548.32113.137.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 11:20 +0100, Douglas Leeder wrote:
> Pavel Machek wrote:
> > On Wed 2009-08-05 17:46:16, Tvrtko Ursulin wrote:
> >> On Wednesday 05 August 2009 03:05:34 Pavel Machek wrote:
> 
> >> Just to make sure you haven't missed this - it is not that they have to 
> >> complete the whole operation before the timeout period (since you mention 
> >> realtime/mlock I suspect this is what you think?), but _during_ the operation 
> >> they have to show that they are active by sending something like keep alive 
> >> messages.
> >>
> >> Or you are worried about failing to meet even that on a loaded system? There 
> >> has to be something like this otherwise hung userspace client would kill the 
> >> whole system.
> > 
> > Of course, I'm worried about failing to meet this on loaded
> > system. And the fact that I _have_ to worry about that means that
> > interface is ugly/broken.
> 
> You mean that in 5 seconds, you won't have any point when you can tell
> the kernel, "I'm still working"?

I have to agree with Pavel here, either you demand the monitor process
is RT/mlock and can respond in time, in which case the interface doesn't
need a 5 second timeout, or you cannot and you have a hole somewhere.

Now having the kernel depend on any user task to guarantee process is of
course utterly insane too.

Sounds like a bad place to be, and I'd rather not have it.

If you really need the intermediate you might as well use a FUSE
filesystem, but I suspect there's plenty of problems there as well.

It all reeks of ugly though..

/me craws back from whence he came.


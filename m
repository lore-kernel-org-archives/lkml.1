Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZHFM7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZHFM7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZHFM7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:59:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60318 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbZHFM7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:59:01 -0400
Date: Thu, 6 Aug 2009 13:58:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Leeder <douglas.leeder@sophos.com>, Pavel Machek <pavel@ucw.cz>,
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
       "mmorley@hcl.in" <mmorley@hcl.in>
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090806135800.7ccb7787@lxorguk.ukuu.org.uk>
In-Reply-To: <200908061348.43625.tvrtko.ursulin@sophos.com>
References: <1248466429.3567.82.camel@localhost>
	<200908061159.45550.tvrtko.ursulin@sophos.com>
	<1249557831.32113.234.camel@twins>
	<200908061348.43625.tvrtko.ursulin@sophos.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We are taking about the kind of fanotify client that says: No you cannot
> > open/read/write/mmap/etc.. this file until I say you can, right?
> 
> Yes and no, it would be more accurate to say "this open takes long while we do 
> something else in the background".

There are two or three ways to handle this

1.	Block the open until the daemon dies or responds
2.	Have a timeout (which would need to be connection configurable)
3.	Require the daemon responds with "in progress" now and then.

For a superuser managed service its no different to an NFS mount which
can go wonky so the only real question is what should fanotify allow non
privileged users to do. The answer would appear anyway to be: not use
this aspect of such a facility.

For the superuser case the fact the daemon can be killed thus releasing
anything stuff is analogous to umount -f of a stuck NFS mount which seems
perfectly good for NFS.

Alan

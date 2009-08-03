Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZHCQ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZHCQ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZHCQ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:56:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbZHCQ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:56:35 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <20090803162303.GA31058@infradead.org>
References: <1248466429.3567.82.camel@localhost>
	 <20090803162303.GA31058@infradead.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 12:55:35 -0400
Message-Id: <1249318535.2447.26.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 12:23 -0400, Christoph Hellwig wrote:
> Before we get started:  You promised yo get rid of the dnotify and
> inotify fields in the inode when moving over those two to fsnotify.
> While the dnotify fields are gone the inotify_watches and inotify_mutex
> fields are still around.  I'd really like to see this done before we
> move on.

In linux-next you will find that those fields are completely unused and
the kernel can be compiled without them with 0 lose of functionality
(they are still used in linus's kernel by the audit system)

The only reason I didn't remove them entirely is because the inotify
kernel interface is EXPORT_SYMBOL.  I plan to leave it around for a
little bit until I'm sure out of tree users don't exist or at least had
enough time to realize they need to use fsnotify.

For all situations I know of at least, those 2 fields can be safely
compiled out.  (aka !CONFIG_INOTIFY)

-Eric


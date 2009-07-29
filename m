Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZG2UQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZG2UQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZG2UQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:16:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbZG2UQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:16:50 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <20090727192342.GA27895@shareable.org>
References: <1248466429.3567.82.camel@localhost>
	 <20090724224813.GK27755@shareable.org>
	 <1248479367.3567.133.camel@localhost>
	 <20090725002916.GB13556@shareable.org>
	 <20090727183354.GM4231@webber.adilger.int>
	 <20090727192342.GA27895@shareable.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:14:15 -0400
Message-Id: <1248898455.2597.59.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 20:23 +0100, Jamie Lokier wrote:
> Andreas Dilger wrote:
> > On Jul 25, 2009  01:29 +0100, Jamie Lokier wrote:
> > > Eric Paris wrote:

> What's wrong with fanotify-using applications generating events when
> they modify files themselves?
> 
> An example was given where app A gets an event and modifies the file,
> then app B gets an event and modifies the file, and app A... cycling.

No the example was the 'open' which the kernel does on behalf of the
listener.  I'm thinking now I should only exclude

OPEN
OPEN_PERM
ACCESS_PERM

as those are the only 3 event types I can see deadlock/recursion
problems with.


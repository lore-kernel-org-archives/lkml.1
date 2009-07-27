Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZG0Ses@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZG0Ses (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZG0Ser
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:34:47 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58083 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZG0Seq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:34:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Mon, 27 Jul 2009 12:33:54 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: fanotify - overall design before I start sending patches
In-reply-to: <20090725002916.GB13556@shareable.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
Message-id: <20090727183354.GM4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248466429.3567.82.camel@localhost>
 <20090724224813.GK27755@shareable.org> <1248479367.3567.133.camel@localhost>
 <20090725002916.GB13556@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25, 2009  01:29 +0100, Jamie Lokier wrote:
> Eric Paris wrote:
> > But maybe I should jsut do the 'if you have fanotify open, you don't
> > create other fanotify events'...   so everyone gets what they expect...
> 
> O_NONOTIFY.  Similar security concerns, more control.
> 
> The security concern is clear: If you allow a process with fanotify
> open to not create events, then any (root) process can open a fanotify
> socket to hide it's behaviour.

I think the "fanotify doesn't generate more fanotify events" makes the
most sense.  Given that the open will be done in the kernel specifically
due to fanotify, this doesn't actually allow the listener to open files
without detection (unlike the "O_NONOTIFY" flag would).  The fanotify
"opens" would only be in response to other processes opening the file.

It might also make sense to verify that the process doing the open has
at least permission to open the file in question (i.e. root) so that
some unauthorized process cannot just get file handles to arbitrary files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


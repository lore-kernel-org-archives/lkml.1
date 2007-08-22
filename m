Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbXHVP1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbXHVP1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbXHVP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:27:35 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:52977 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356AbXHVP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:27:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18124.21940.10785.831274@stoffel.org>
Date: Wed, 22 Aug 2007 11:26:44 -0400
From: "John Stoffel" <john@stoffel.org>
To: Valdis.Kletnieks@vt.edu
Cc: John Stoffel <john@stoffel.org>, Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: <29735.1187737456@turing-police.cc.vt.edu>
References: <20070820225415.GL3956@digitalkingdom.org>
	<18123.5699.405125.137517@stoffel.org>
	<46CB1A78.7040102@redhat.com>
	<18123.13314.43009.263383@stoffel.org>
	<29735.1187737456@turing-police.cc.vt.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Valdis" == Valdis Kletnieks <Valdis.Kletnieks@vt.edu> writes:

Valdis> On Tue, 21 Aug 2007 14:50:42 EDT, John Stoffel said:
>> Now maybe those issues are raised when you have a Linux NFS server
>> with Solaris clients.  But in my book, reliable NFS servers are key,
>> and if they are reliable, 'soft,intr' works just fine.

Valdis> And you don't need all that ext3 journal overhead if your disk
Valdis> drives are reliable too.  Gotcha. :)

Yeah yeah... you got me.  *grin*   In a way.  How to say this.  NFS is
like ext2 in some ways.  No real protection from errors unless you
turn on possibly performance killing aspects of the code.  

Ext3 takes it to a higher level of consistency without compromising as
much on the performance.  

RAID can be the base of both of these things, and that helps alot.  If
your RAID is reliable.  

So, my NetApps are reliable because they have NVRAM for performance,
and it's battery backed for reliability.  On that they build the
Volume and Filesystem stuff, which also has performance and
reliability built-in.  

On top of this, they have NFS (or CIFS or other protocols, but I use
only NFS).  And we actually default to "proto=tcp,soft,intr" for all
our mounts.  We do this for performance, because we're confident of
the underlying reliability of the layers below it.  All the way down
to the Network switches in a way.  Though I admit we don't dual-path
everything since we don't have enough need for that level of
reliability.

So that's where I'm coming from.  Now, I'd be happy to be proven
wrong, but I'd like to see people giving test scripts which can be run
on a client to simulate failures and such so I can run them here in my
environment as test.  Maybe I'll change my mind.  Maybe I won't.  

At least we've got choice.  :]

John

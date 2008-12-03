Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYLCPuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYLCPuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYLCPuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:50:05 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:49932 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYLCPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:50:03 -0500
Date: Wed, 3 Dec 2008 16:50:01 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Pavel Machek <pavel@suse.cz>
cc: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
In-Reply-To: <20081203084639.GB1944@ucw.cz>
Message-ID: <Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu>
 <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
 <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu>
 <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu>
 <20081203084639.GB1944@ucw.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. fsync() seeems surprisingly high on Rusty's list of broken
> interfaces classification ('impossible to use correctly').
> 
> I wonder if some reasonable solution exists? Mark filesystem as failed
> on first  write error is one of those (and default for ext2/3?). Did
> SGI/big unixen solve this somehow?

When OS/2 hit write error, it wrote to another location on disk and added 
this to its sector remap table. It could remap both metadata and data this 
way. But today it is meaningless, because the same algorithm is 
implemented in disk firmware. Write errors are reported for disk 
connection problems, not media problems.

For connection problems, another solution may be to retry writes 
indefinitely until the admin aborts it or reconnects the disk. But I don't 
know how common these recoverable disk connection errors are.

> > The reality is that most applications don't proper error checking, and
> > even fewer actually call fsync(), so if you are putting your root
> > filesytem on a 32G flash card, and it pops out easily due to hardware
> > design issues, the question of whether fsync() gets properly progated
> > to all potentially interested applications is the ***least*** of your
> > worries.

If you are running a transaction processing software, then it is a very 
important worry. All the database software is written with the assumption 
that when the database returns transaction committed, then the changes are 
permanent.

Most of the business software can deal with the fact that the server 
crashes, but can't deal with the fact that database returnes committed 
status for transaction that wasn't really committed.

Mikulas

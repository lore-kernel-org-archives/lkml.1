Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYLCRh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYLCRh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLCRhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:37:48 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:42500 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLCRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:37:47 -0500
Date: Wed, 3 Dec 2008 18:37:45 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
In-Reply-To: <20081203155449.6ea98768@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0812031754040.25439@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu>
 <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
 <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu>
 <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu>
 <20081203084639.GB1944@ucw.cz> <Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz>
 <20081203155449.6ea98768@lxorguk.ukuu.org.uk>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Alan Cox wrote:

> > implemented in disk firmware. Write errors are reported for disk 
> > connection problems, not media problems.
> 
> Media errors are reported for writes when the drive knows there are
> problems. That may be deferred to the cache flush afterwards but the
> information is still generated and shipped back to us - eventually.

It a question, how to process cache flush errors correctly. A cache flush 
error reported for one filesystem may belong to the data written by other 
filesystem. So should some flag "there was an error" be set for all 
partitions and report it to every filesystem when it does cache flush? Or 
record the time of the last error in the driver and let the filesystem 
query it (so that the filesystem can tell if the error happened before or 
after it was mounted).

BTW. how does SCSI report cache flush errors? Does it report them on 
SYNCHRONIZE CACHE command or does it report them on defered senses?

Another point is that unless the sector remap table is full, there should 
be no cache flush errors.

> > For connection problems, another solution may be to retry writes 
> > indefinitely until the admin aborts it or reconnects the disk. But I don't 
> > know how common these recoverable disk connection errors are.
> 
> CRC errors, lost IRQs and the like are retried by the midlayer and
> drivers and the error handling strategies will also try things like
> reducing link speeds on repeated CRC errors.

I meant for example loose cable or so --- does it make sense to retry 
indefinitely (until the admin plugs the cable or unmounts the filesystem) 
or return error to the filesystem after few retries?

Mikulas

> Alan
> 

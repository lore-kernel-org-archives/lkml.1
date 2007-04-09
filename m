Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXDIUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXDIUIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXDIUIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:08:44 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:63750 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456AbXDIUIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:08:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17946.40257.794493.294518@smtp.charter.net>
Date: Mon, 9 Apr 2007 16:08:33 -0400
From: "John Stoffel" <john@stoffel.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John Stoffel" <john@stoffel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <200704091549.51805.gene.heskett@gmail.com>
References: <200704091007.58535.gene.heskett@gmail.com>
	<200704091137.01336.gene.heskett@gmail.com>
	<17946.29660.368403.553290@smtp.charter.net>
	<200704091549.51805.gene.heskett@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gene" == Gene Heskett <gene.heskett@gmail.com> writes:

Gene> I wouldn't touch dump/restore with a 50 foot pole, particularly
Gene> since I have serious doubts about it viability in the LVM
Gene> environment.

Why?  It's can't be any worse than Tar with it's silly assumption
about the static device numbers, which are shown in their own docs to
be an invalid assumption over NFS, so why enforce them locally?  

On Linux, dump/restore are open source, so it's not like you can't get
your data back, you know the format it's written in.  Any backup
software has problems with filesystems which change underneath them as
they run, esp for incremental backups.  

The only sure strategy is to do your dumps in single user mode, with
only one process touching the filesystem during the backup window.
This obviously won't fly in a 24x7 environment, so people take their
calculated chances and run backups with the system live.  

Some people are working to be able to take snapshots of live
filesystems, then backups the snapshots, but that's still a work in
progress right now.  I'd personally love to do that, but not quite
yet. 

Gene> For those of you with big tapes that can hold a complete dump of
Gene> every partition (and partitions is the only way dump works in
Gene> case some have forgotten), go ahead and use dump/restore.  Tar
Gene> quite simply, allows one to break his backup files down into
Gene> small enough pieces that a tape drive that's only 20% of the
Gene> system drives size is totally usable. 

So does Bacula.  *grin*  It will happily span backups across multiple
volumes (read tapes).  

The problem with Amanda is that you have to *manually* break down your
filesystem into chunks small enough to fit on a single volume.  I
don't have to think about it with Bacula.

Gene> I ran dds2 tapes for a long time, and it wasn't at all unusual
Gene> to have amanda fill those to the 95% or better mark every night
Gene> for a week running, without ever hitting EOT.

The problem with Amanda for the longest time was that if you had a
full backup which spanned more than one tape, you were screwed.  

>> This tar borkness is pretty annoying, since Amanda (from the docs
>> page) only keeps indexes in terms of host/filesystem/path/date,
>> nothing about the major/minor (device) numbers.
>> 
>> It just re-inforces my desire to never use Amanda again.

Gene> Your call, that's what this linux thing is all about.  But do I
Gene> not recall your name from the amanda lists at some point in the
Gene> last 8+ years?

Probably, but it's been a long time since I was active in Amanda,
probably back in my WPI days (john@wpi.edu) or my Fluent days
(jfs@fluent.com), but I honestly don't remember.

As I said, the big problem with Amanda for the longest time (and which
has now been worked around I understand) was a single backup which had
to span multiple volumes.  

Bacula does this all for you, and works better than Amanda IMHO.  It
also allows you to stage to disk and then to DVD or other types of
volumes.  

And it doesn't have amanda's inistence of writing to a new piece of
media each day either.  Which I admit is a tradeoff, but for a home
system, not having to swap tapes daily is a big help, and saves me
money.  DLTIV tapes aren't cheap, even on ebay...

Heck, if you don't trust Dump, find tar to be broken, what about cpio?
*grin*

John

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYHPPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYHPPRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHPPRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 11:17:44 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56917 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbYHPPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:17:43 -0400
Date: Sat, 16 Aug 2008 11:17:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Dolding <oiaohm@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, david@lang.hm, rmeijer@xs4all.nl,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080816151714.GA8422@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Dolding <oiaohm@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>, david@lang.hm,
	rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
	Rik van Riel <riel@redhat.com>, davecb@sun.com,
	linux-security-module@vger.kernel.org,
	Adrian Bunk <bunk@kernel.org>,
	Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl> <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com> <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm> <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com> <20080815210942.4e342c6c@infradead.org> <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com> <20080816093952.GF22395@mit.edu> <e7d8f83e0808160438y73c5b24cl306144f512ef6013@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d8f83e0808160438y73c5b24cl306144f512ef6013@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 09:38:30PM +1000, Peter Dolding wrote:
> 
> UDF undelete and unhide options and ISO showassoc  makes more files
> appear on those formats.  UDF and ISO hidden files are one of the
> nasties.  AV scans the disk calls it clean.  Remount it with the other
> options enabled nice little bit of magic hidden infected files could
> turn up.   Black holed.
> 
> What is the worst bit about this knowing the luck of this world.
> Some people will mount the disks/partitions with the option that
> displays the virus with a OS without a anti-virus because another
> computer said the disk was clean.

You have this problem anyway, given that AV database updates are
coming every few hours; so if you scan the disk at noon, and an AV
update comes at 1pm it may be that there were malware that wasn't
detected by the noon DB, but will be detected by the 1pm DB.

And for non read-only filesystems (i.e., anything other than UDF and
ISO), anytime the filesystem is unmounted, the OS is going to have to
assume that it might have been modified by some other system before it
was remounted, so realistically you have to rescan after remounting
anyway, regardless of whether different mount options were in use.

So I draw a very different set of conclusions than yours given your
obervations of all of the ways that an AV scanner might miss certain
viruses, due to things like alternate streams that might not be
visible at the time, snapshotting filesystems where the AV scanner
might not know how to access past snapshots, and hence miss malware. 

I don't believe that this means we have to cram all possible
filesystem semantics into the core VFS just for the benefit of AV
scanners.  I believe this shows the ultimate fallacy that AV scanners
can be foolproof.  It will catch some stuff, but it will never be
foolproof.  The real right answer to malware are things like not
encouraging users to run with the equivalent of Windows Administrator
privileges all the time (or training them to say, "Yeah, Yeah" every
time the Annoying Vista UAC dialog box comes up and clicking "ok"),
and using mail user agents that don't auto-run contents as soon as you
open a mail message in the name of "the user wants functionality, and
we're going to let them have it" attitude of Microsoft.

      	       	   	     	 	     		- Ted

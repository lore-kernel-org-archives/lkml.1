Return-Path: <linux-kernel-owner+w=401wt.eu-S1765501AbZDAXos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765501AbZDAXos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbZDAXog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:44:36 -0400
Received: from thunk.org ([69.25.196.29]:50465 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbZDAXof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:44:35 -0400
Date: Wed, 1 Apr 2009 17:50:40 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090401215040.GA7350@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	"Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
	Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <1238417751.30488.12.camel@think.oraclecorp.com> <20090331235509.GU26138@disturbed> <1238590413.18549.7.camel@think.oraclecorp.com> <49D38B22.1050105@ursus.ath.cx> <1238601746.18549.55.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238601746.18549.55.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 12:02:26PM -0400, Chris Mason wrote:
> 
> If we crash during the rsync, the backup logs will yell.  If we crash
> just after the rsync, the backup logs won't know.  The data could still
> be gone.

So have rsync call the sync() system call before it exits.  Not a big
deal, and not all that costly.  So basically what I would suggest
doing for people who are really worried about rsync performance with
flush-on-rename is to create a patch to rsync which creates a new
flag, --unlink-before-rename, which will defeat the flush-on-rename
hueristic; and if this patch also causes rsync to call sync() when it
is done, it should be quite safe.

						- Ted

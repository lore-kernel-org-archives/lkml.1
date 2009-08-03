Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZHCQJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZHCQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZHCQJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:09:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbZHCQJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:09:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: 2.6.31-rc5: Reported regressions from 2.6.30
Date: Mon, 3 Aug 2009 18:09:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Mikael Pettersson <mikpe@it.uu.se>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <alpine.LFD.2.01.0908021456430.3352@localhost.localdomain> <20090803143108.GA12041@cmpxchg.org>
In-Reply-To: <20090803143108.GA12041@cmpxchg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031810.00505.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Johannes Weiner wrote:
> On Sun, Aug 02, 2009 at 03:22:01PM -0700, Linus Torvalds wrote:
> 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13815
> > > Subject		: emacs -nw compilation doesn't show the error message
> > > Submitter	: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > Date		: 2009-07-23 06:22 (11 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d945cb9cce20ac7143c2de8d88b187f62db99bdc
> > 
> > Same old pty bug, same fix: commit e043e42bdb.
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13813
> > > Subject		: Hangups in n_tty_read()
> > > Submitter	: Johannes Weiner <hannes@cmpxchg.org>
> > > Date		: 2009-07-16 18:48 (18 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=124777019920579&w=4
> > 
> > Hmm. Worth testing that same fix, although the symptoms here are not 
> > exactly the same.
> 
> Hm, I had no debugging enabled, but I think a silent hang in
> 
> 	pty_write()
> 	  tty_flip_buffer_push()
> 	    flush_to_ldisc()
> 
> can cause the receiving side
> 
> 	tty_read()
> 	  n_tty_read()
> 
> to wait forever for updates.  I haven't looked closely.  It seems to
> be gone with your latest master in any case.

Thanks, closed (in fact I closed it earlier already).

Rafael

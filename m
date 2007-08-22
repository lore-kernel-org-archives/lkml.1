Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbXHVKDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbXHVKDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbXHVKDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:03:38 -0400
Received: from THUNK.ORG ([69.25.196.29]:37791 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbXHVKDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:03:37 -0400
Date: Wed, 22 Aug 2007 06:03:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Valdis.Kletnieks@vt.edu
Cc: John Stoffel <john@stoffel.org>, Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070822100325.GB25150@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	John Stoffel <john@stoffel.org>,
	Peter Staubach <staubach@redhat.com>,
	Robin Lee Powell <rlpowell@digitalkingdom.org>,
	linux-kernel@vger.kernel.org
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org> <29735.1187737456@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29735.1187737456@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:04:16PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 21 Aug 2007 14:50:42 EDT, John Stoffel said:
> 
> > Now maybe those issues are raised when you have a Linux NFS server
> > with Solaris clients.  But in my book, reliable NFS servers are key,
> > and if they are reliable, 'soft,intr' works just fine.
> 
> And you don't need all that ext3 journal overhead if your disk drives
> are reliable too.  Gotcha. :)

Err, no.  The ext3 journal overhead buys you not needing to fsck after
an unclean shutdown, and safety against crap getting written to the
inode table on an unclean power hit while the disk drive is writing
and the memory goes insane before the DMA engine and disk drive stop
working from the voltage on the power supply rails.  (Hence my advice
that if you use XFS on Linux, make *sure* you have a UPS; on machines
such as the SGI Indy they added bigger capacitors to the PSU and a
real power fail interrupt, but PC-class hardware is
inexpensive/crappy, so it doesn't have such niceties.)

     	    	     	  	     	    - Ted



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYCNQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYCNQuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYCNQuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:50:13 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52211 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752388AbYCNQuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:50:11 -0400
Date: Fri, 14 Mar 2008 12:49:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ric Wheeler <ric@emc.com>
Cc: Benny Amorsen <benny+usenet@amorsen.dk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080314164952.GA7767@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <ric@emc.com>,
	Benny Amorsen <benny+usenet@amorsen.dk>,
	linux-kernel@vger.kernel.org
References: <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk> <20080314125656.GA7412@mit.edu> <47DA9DF8.5010600@emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA9DF8.5010600@emc.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 11:47:04AM -0400, Ric Wheeler wrote:
> The ingest rate at the time of a power hit makes a huge difference as well 
> - basically, pulling the power cord when a box is idle is normally not 
> harmful. Try that when you are really pounding on the disks and you will 
> see corruptions a plenty without barriers ;-)

Oh, no question.  But the fact that it mostly works when the box is
idle means the hard drive firmware is reasonably aggressive about
pushing data from the write cache out to the platters when it can.

> One note - the barrier hit for apps that use fsync() is just half an order 
> of magnitude (say 35 files/sec instead of 120 files/sec). If you don't 
> fsync() each file, the impact is lower still.
>
> Still expensive, but might be reasonable for home users on a box with 
> family photos, etc.

It depends on the workload, obviously.  I thought I remember someone
on this thread talking about benchmark where they went from ~2000 to
~20 ops/sec once they added fsync().  I'm sure that was an extreme
benchmarking workload that isn't at all representative of real-life
usage, where you're usually do something else modifying the metadata
of many tiny files over and over again.  :-)

It's also the case that a home user's fileserver is generally
quiscent, which is probably why we aren't hearing lots of stories
about home NAS servers (which I bet probably don't enable write
barriers) trashing vast amounts of user data.....

						- Ted



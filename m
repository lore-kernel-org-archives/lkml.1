Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYCNM52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYCNM52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYCNM5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:57:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51596 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbYCNM5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:57:18 -0400
Date: Fri, 14 Mar 2008 08:56:56 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080314125656.GA7412@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Benny Amorsen <benny+usenet@amorsen.dk>,
	linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3fxutcz2s.fsf@ursa.amorsen.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 12:41:31PM +0100, Benny Amorsen wrote:
> Ric Wheeler <ric@emc.com> writes:
> 
> > The only really safe default is to disable the write cache by default
> > or possibly dynamically disable the write cache when barriers are not
> > supported by a drive. Both have a severe performance impact and I am
> > not sure that for most casual users it is a good trade.
> 
> So people ARE running their disks in a mode similar to Ramback.

Similar, but not as aggressive.  Remember, the size of the write cache
on the hard drive is relatively small (small number of megabytes), and
the drive generally is relatively aggressive about getting the data
out to the platters; it's probably not going to keep unwritten data on
the platters for minutes or hours at a time, let alone days.  Of
course, unless you use write barriers or some kind of explicit write
ordering, it's going to write stuff out in an order which is
convenient to the hard drive, not necessarily an order convenient to
the filesystem.

Also, if the system crashes, you don't lose the data in hard drive's
write cache, where as the data in Ramback is likely gone.  And Ramback
is apaprently keeping potentially several gigabytes dirty in memory
and *not* writing it out very aggressively.  So the exposure is one of
degree.

In practice, it's interesting that we've had so few people reporting
massive data loss despite the lack of the use of write barriers.
Sure, in absolutely critical situations, it's not a good thing; but if
I had a mail server, where I really wanted to make sure I didn't lose
any e-mail, having a small UPS which could keep the server going for
just a few minutes so it could do a controlled shutdown on a power
failure is probably a better engineering solution from a
cost/benefit/performance point of view, compared to turning on write
barriers and taking up to two orders of magnitude worth of performance
hit.

						- Ted

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYCNT3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYCNT3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYCNT3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:29:45 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33550 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912AbYCNT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:29:44 -0400
Date: Fri, 14 Mar 2008 15:29:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ric Wheeler <ric@emc.com>, Benny Amorsen <benny+usenet@amorsen.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: writeback cache dangers Re: [ANNOUNCE] Ramback: faster than a
	speeding bullet
Message-ID: <20080314192912.GB13733@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Ric Wheeler <ric@emc.com>, Benny Amorsen <benny+usenet@amorsen.dk>,
	linux-kernel@vger.kernel.org
References: <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk> <20080314125656.GA7412@mit.edu> <47DA9DF8.5010600@emc.com> <20080314190357.GB7151@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314190357.GB7151@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 08:03:57PM +0100, Pavel Machek wrote:
> 
> > The ingest rate at the time of a power hit makes a huge 
> > difference as well - basically, pulling the power cord 
> > when a box is idle is normally not harmful. Try that 
> > when you are really pounding on the disks and you will 
> > see corruptions a plenty without barriers ;-)
> 
> I tried that, and could not get a corrruption. cp -a on big kernel
> trees, on sata disk with writeback cache and no barriers... and I
> could not cause fs corruption. ext3.
> 
> I'd like to demo danger of writeback cache. What should I do?

Ext3's journal probably hides a huge number of problems.  I'd try
something with a lot more parallel modifications to metadata.  Say
postmark with a large number of threads.  It would be interesting
actually to get some controlled results of exactly how busy a
filesystem has to be before you get filesystem corruption (which I
would check explicitly running "e2fsck -f" e2fsck after pulling the
plug on the drive).

					- Ted

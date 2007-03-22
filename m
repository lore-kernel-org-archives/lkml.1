Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXCVP7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXCVP7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933730AbXCVP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:59:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701AbXCVP7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:59:10 -0400
Date: Thu, 22 Mar 2007 15:58:56 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Kernel hackers <linux-kernel@vger.kernel.org>,
       fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: BUG: Files corrupt after moving LVM volume to USB disk
Message-ID: <20070322155856.GA5448@agk.surrey.redhat.com>
Mail-Followup-To: Marti Raudsepp <marti@juffo.org>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	fsdevel <linux-fsdevel@vger.kernel.org>
References: <2a12af650703200334u2b94bbcbt2aab8e94b6f2a527@mail.gmail.com> <20070321155039.GM22466@csclub.uwaterloo.ca> <2a12af650703210915r35d2d1a1q30f10020db269098@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a12af650703210915r35d2d1a1q30f10020db269098@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 06:15:47PM +0200, Marti Raudsepp wrote:
> >On Tue, Mar 20, 2007 at 12:34:08PM +0200, Marti Raudsepp wrote:
> >lvmove
> >>  wouldn't move the partition back to /dev/sda5 after "defragmenting" it.)

> However, when attempting to move back the LV, the allocater can create two
> extents, but the "mirror" LVM target does not appear to support regions that
> are continuous on one copy and fragmented on another.
 
This is entirely a user-space restriction, and a fix is finally on the
cards.

> I even tried explicitly specifying --alloc= to lvmove, and it didn't have 
> any
> effect, confirming that it's not about allocation, but likely the "mirror"
> stage of the move.

The workaround is to instruct 'pvmove' how to break up the move into two
or more pieces by specifying ranges of Physical Extents on the command
line (see man pages).  E.g. /dev/sdc:10000-19999:30000-
 
Alasdair
-- 
agk@redhat.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYLBQrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYLBQrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYLBQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:47:15 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49631 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755529AbYLBQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:47:13 -0500
Date: Tue, 2 Dec 2008 11:47:09 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andres Freund <andres@anarazel.de>
Cc: Andreas Dilger <adilger@sun.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20081202164709.GC18162@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andres Freund <andres@anarazel.de>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <200811291418.24672.andres@anarazel.de> <200812012116.08510.andres@anarazel.de> <20081202075712.GA16172@mit.edu> <200812021559.05103.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812021559.05103.andres@anarazel.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 03:58:53PM +0100, Andres Freund wrote:
> Ok. The system now runs (without problems) with the patch enabled and I can 
> get the debug output.
> 30 Minutes after boot the system still returns to zero dirty blocks and the 
> free blocks seem to stay in a sensible range.
> I will let it run for a while and report back if either something interesting 
> happens or the problem reappears and I am seeing no significant amount of dirty 
> blocks.

You say you are using Postgres, right?  Something you might try to see
if it triggers the problem it is creating a new database and then
restoring some database dump/backup into that new database.  Some
databases expand into a new table space (or whatever terminology
Postgres uses) by random writes into a sparse portion of the file.
This could be triggering the problem, or at least trigger the problem
more quickly.

The other thing I wanted to ask is whether "df" was showing the 37%
in-use statistic at the time, or was that after you rebooted.  And
although I hate to ask it, you're sure this isn't the standard "delete
an in-use file but not get the space back" Unix trap, right?

Thanks, regards,

						- Ted

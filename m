Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXJ2OMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXJ2OMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXJ2OMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:12:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30816 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXJ2OMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:12:09 -0400
Date: Mon, 29 Oct 2007 10:10:01 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Mike Waychison <mikew@google.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
Message-ID: <20071029101001.4378a7cf@think.oraclecorp.com>
In-Reply-To: <E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>
References: <20071026233732.568575496@crlf.corp.google.com>
	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 18:57:06 +0100
Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> Hi,
> 
> ->bmap is ugly and horrible!  If you have to do this at the very
> least please cause ->bmap64 to be able to return error values in case
> the file system failed to get the information or indeed such
> information does not exist as is the case for compressed and
> encrypted files for example and also for small files that are inside
> the on-disk inode (NTFS resident files and reiserfs packed tails are
> examples of this).
> 
> And another of my pet peeves with ->bmap is that it uses 0 to mean  
> "sparse" which causes a conflict on NTFS at least as block zero is  
> part of the $Boot system file so it is a real, valid block...  NTFS  
> uses -1 to denote sparse blocks internally.

Reiserfs and Btrfs also use 0 to mean packed.  It would be nice if there
was a way to indicate your-data-is-here-but-isn't-alone.  But that's
more of a feature for the FIEMAP stuff.

-chris

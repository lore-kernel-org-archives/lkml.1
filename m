Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYARAcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYARAcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYARAb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:31:57 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45320 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYARAb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:31:56 -0500
In-Reply-To: <478FE22D.9030907@emc.com>
To: Ric Wheeler <ric@emc.com>
Cc: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Daniel Phillips <phillips@google.com>,
       Rik van Riel <riel@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Valerie Henson <val.henson@gmail.com>
MIME-Version: 1.0
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Thu, 17 Jan 2008 16:31:48 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 01/17/2008
 19:31:50,
	Serialize complete at 01/17/2008 19:31:50
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler <ric@emc.com> wrote on 01/17/2008 03:18:05 PM:

> Theodore Tso wrote:
> > On Wed, Jan 16, 2008 at 09:02:50PM -0500, Daniel Phillips wrote:
> >> Have you observed that in the wild?  A former engineer of a disk 
drive
> >> company suggests to me that the capacitors on the board provide 
enough
> >> power to complete the last sector, even to park the head.
> >>
> 
> Even if true (which I doubt), this is not implemented.
> 
> A modern drive can have 16-32 MB of write cache. Worst case, those 
> sectors are not sequential which implies lots of head movement.

We weren't actually talking about writing out the cache.  While that was 
part of an earlier thread which ultimately conceded that disk drives most 
probably do not use the spinning disk energy to write out the cache, the 
claim was then made that the drive at least survives long enough to finish 
writing the sector it was writing, thereby maintaining the integrity of 
the data at the drive level.  People often say that a disk drive 
guarantees atomic writes at the sector level even in the face of a power 
failure.

But I heard some years ago from a disk drive engineer that that is a myth 
just like the rotational energy thing.  I added that to the discussion, 
but admitted that I haven't actually seen a disk drive write a partial 
sector.

Ted brought up the separate issue of the host sending garbage to the disk 
device because its own power is failing at the same time, which makes the 
integrity at the disk level moot (or even undesirable, as you'd rather 
write a bad sector than a good one with the wrong data).

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems


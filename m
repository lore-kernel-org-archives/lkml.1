Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbXIMQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbXIMQFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbXIMQFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:05:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757637AbXIMQFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:05:30 -0400
Date: Thu, 13 Sep 2007 11:05:28 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Gabor Gombas <gombasg@sztaki.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <20070913100803.GG11567@boogie.lpds.sztaki.hu>
Message-ID: <20070913104609.K41932@pkunk.americas.sgi.com>
References: <20070912144128.D5573@pkunk.americas.sgi.com>
 <20070913100803.GG11567@boogie.lpds.sztaki.hu>
Organization: Silicon Graphics, Inc.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Gabor Gombas wrote:

> On Wed, Sep 12, 2007 at 03:37:44PM -0500, Brent Casavant wrote:
> 
> > System V shmem is right out because the IPC key is publicly
> > visible and there is no combination of permissions which
> > will allow sharing the segment with just one other process
> > (or at least just one other user).  To my knowledge Linux's
> > implementation doesn't provide ACLs for SysV shmem.  SGI's
> > proposed XPMEM suffers from the same problems for my purposes.
> 
> SYSV shared memory has the concept of separate creator and owner ID's,
> so you can share the shmem segment between exactly two users. Just use
> IPC_SET and set shm_perm.uid to the user ID of the peer process.

Hmm.  This will work as long as the peer process is running setuid
to it's own unique user.  Excellent idea!  Since I need to make the
program setuid to avoid non-priveleged ptrace attacks, this is a
terrific solution.

> I think your worries about permissions has been cleared by the other
> posts, but there is still a problem: the client may call ftruncate() on
> the file descriptor, and then your daemon will get a nice SIGBUS when it
> tries to access the shared memory. Handling that gracefully may not be
> trivial esp. if your daemon is multi-threaded. SYSV shmem is _much_
> nicer when you want shared memory between unrelated/untrusted processes.

I'm actually not so concerned about the client -- that code will be
trusted as well.  The problem I'm trying to solve is preventing any
non-priveleged code except the server and client from gaining access
to their shared memory area.  With the feedback I've received from
this thread I think a solid design is emerging, some of which will
need to be solved by system configuration by the sysadmin.

Thanks,
Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong

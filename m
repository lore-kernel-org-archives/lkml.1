Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXILX2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXILX2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXILX1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:27:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755272AbXILX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:27:53 -0400
Date: Wed, 12 Sep 2007 18:27:52 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <20070912224955.GC8181@ftp.linux.org.uk>
Message-ID: <20070912180937.Y5573@pkunk.americas.sgi.com>
References: <20070912144128.D5573@pkunk.americas.sgi.com> <jetzpza7ci.fsf@sykes.suse.de>
 <20070912172519.N5573@pkunk.americas.sgi.com> <20070912224955.GC8181@ftp.linux.org.uk>
Organization: Silicon Graphics, Inc.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Al Viro wrote:

> On Wed, Sep 12, 2007 at 05:44:30PM -0500, Brent Casavant wrote:
> 
> > P.S. By the way, there doesn't seem to be a way to remove /proc/#/mem
> >      files.  That might be an additional nicety -- programs worried about
> >      being snooped could unlink their own entry.  /dev/mem and /dev/kmem
> >      can simply be removed by the sysadmin of such a system.  If all of
> >      that were done you'd have to resort to attacking crash dumps, core
> >      dumps, or via something like kdb to extract "hidden" data.
> 
> Give me a break.  And learn about ptrace(2).  This "unlinking" bullshit
> buys you zero additional security, both for /proc/*/mem and for /dev/mem
> (see mknod(2)).

Yes, I fully understand that mknod can recreate the nodes -- however
only the superuser can do so, and if the superuser is attacking a
process all bets are off anyway.  OK, so /dev/*mem isn't to worry
about, since it's already owned by root.  Still, /proc/#/mem is owned
by the user, not root, leaving it potentially open to inspection by
third party processes.

I'm thinking out loud.  Sorry to cause any grief.

My (limited) understanding of ptrace is that a parent-child
relationship is needed between the tracing process and the traced
process (at least that's what I gather from the man page).  This
does give cause for concern, and I might have to see what can be
done to alleviate this concern.  I fully realize that making this
design completely unassilable is a fools errand, but closing off
as many attack vectors as possible seems prudent.

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong

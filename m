Return-Path: <linux-kernel-owner+w=401wt.eu-S934146AbXILVJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbXILVJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbXILVIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:08:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933628AbXILVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:08:04 -0400
Message-ID: <46E85528.3010405@zytor.com>
Date: Wed, 12 Sep 2007 14:07:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Brent Casavant <bcasavan@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
References: <20070912144128.D5573@pkunk.americas.sgi.com>
In-Reply-To: <20070912144128.D5573@pkunk.americas.sgi.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brent Casavant wrote:
> 
> I could mmap a temporary tmpfs file (tmpfs so that if there is a
> machine crash no sensitive data persists) which is created with
> permissions of 0, immediately unlink it, and pass the file
> descriptor through an AF_UNIX socket.  This does open up a very
> small window of vulnerability if another process is able to chmod
> the file and open it before the unlink.
> 

To avoid this window, typically one creates a temporary directory first,
with 0700 permissions.  Make sure you verify that you actually created
the directory, and watch out for symlink attacks.  Then you create the
file in that directory.

This doesn't prevent another process owned by the same user (or root)
from attaching, but such a process can ptrace you or touch yoour /proc
spaec just as well, so you're screwed anyway (modulo SELinux-type policies.)

> However, it occurs to me that this problem goes away if there were
> a method create a file in an unlinked state to begin with.  However
> there does not appear to be any such mechanism in Linux's open()
> interface.  A bit of Googling indicates that Hurd has an O_NOLINK
> flag which seems to accomplish what I'd need, but Linux doesn't
> implement such a flag.  There was some discussion of this in various
> lkml threads in the past, but none that went anywhere.  Perhaps
> the best an explaining why other mechanisms (i.e. directories
> with particular permissions aren't a solution) is:
> 
> 	http://marc.info/?l=linux-kernel&m=93032806224160&w=2
> 

This link talks about file flags handling.  I don't see the relevance to
this problem at all.  However, this is a very long thread, so if there
is anything specific that you want to point to, then please elucidate.

> Of course it is reasonable to take the stance that if root or the
> daemon's user are malicious, all bets are off anyway.

Yup, see above.

	-hpa

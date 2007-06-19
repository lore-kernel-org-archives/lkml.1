Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXFSP2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXFSP2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXFSP2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:28:32 -0400
Received: from hera.cwi.nl ([192.16.191.8]:50052 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbXFSP2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:28:31 -0400
Date: Tue, 19 Jun 2007 17:28:18 +0200
From: Andries Brouwer <Andries.Brouwer@cwi.nl>
To: Karel Zak <kzak@redhat.com>
Cc: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: mount-2.12r-ggk.tar.gz
Message-ID: <20070619152818.GA16363@apps.cwi.nl>
References: <200706191238.l5JCcxg14300@apps.cwi.nl> <20070619141528.GS7226@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070619141528.GS7226@petra.dvoda.cz>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 04:15:28PM +0200, Karel Zak wrote:

>  We use GIT for development, the utils/util-linux-ng is for releases.

Aha - and there have not been any releases yet.

> > Anyway, Dirk Gerrits, René Gabriël and Peter Kooijmans sent me

I meant Dirk Gerrits, René Gabriëls and Peter Kooijmans, sorry

> > [By the way, this shared subtree stuff is a bit messy,
> > and impossible to support correctly by mount without help
> > from the kernel. So far the shared/slave/unbindable status
> > of mounts is not visible in /proc/mounts or /proc/$$/mountstats.
> 
>  Unfortunately, you're right.
> 
>  We need something like /proc/PID/mounts_propagation
>  (see 2nd patch in):
>  http://www.mail-archive.com/util-linux-ng@vger.kernel.org/msg00136.html

Hmm - mounts_new - very ugly. Reminds me of oldolduname and family.
I see that you followed up and said the right things.

> > The above mount makes a feeble attempt to record these flags
> > in /etc/mtab, but will fail in any nontrivial situation.]
> 
>  I don't think that mtab is a good place for this shared subtree
>  stuff. The mtab needs to die.

Perhaps. Perhaps not.

On the one hand I think there is a place for arbitrary user-space info
about mounted filesystems. With information about who mounted, and at what time.
What the icon is that should represent this filesystem. What resources are
associated to this mount, and which program must do the cleanup. Etc.
Today there is not much user-space info, but there is some.

On the other hand, the fact that the namespace is per-process
complicates matters. There is no natural location for a per-process mtab.
But maybe the easy solution is just to leave that to the users by giving
mount(8) an option "-M mtabfile".

What is missing is a way for user space to find out what the actual
kernel situation is, and that makes /etc/mtab imperfect. The right
implementation of "mount" (without options, roughly "cat /proc/mounts")
would be for mount to ask the kernel about all existing mounts,
merge the user space type information found in /etc/mtab, and give the result
to the user. (And update mtab if necessary.)

For the filesystem we have readdir() and stat() to find out about
the file hierarchy. I would like readmounts() and statmount() to find out
about the tree of mounts and the flags of each mount. Without using /proc.

Andries

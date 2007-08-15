Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbXHONaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbXHONaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXHONaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:30:25 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49534 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbXHONaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:30:22 -0400
Date: Wed, 15 Aug 2007 09:30:21 -0400
To: Michael Tharp <gxti@partiallystapled.com>
Cc: alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070815133021.GB9412@csclub.uwaterloo.ca>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C2F96D.5030908@partiallystapled.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 09:02:37AM -0400, Michael Tharp wrote:
> This jumped out at me right away. In such a system, an attacker with
> write permissions on a "sticky" directory like /tmp could probe for
> others' files by attempting to create them and recording all cases where
> permission was denied due to an existing, hidden file. But of course,
> this was just an example of something a less UNIX-y permission scheme
> could do, not a key part of such a design.
> 
> Personally, what I'd like to see is a better way of dealing with
> propagation of ownership. Currently, in order to allow "collaboration"
> directories where a directory tree is owned by a certain group and
> anyone in that group can write and create files, one has to change the
> system umask, use a magical bit on the collaboration directory to
> propagate group ownership, and create a group for every user on the
> system in order to keep their personal files safe with the new umask.
> This seems highly flawed. I suggest that propagation of group ownership
> should be the default mode, not a special one, and that the
> group-writable permissions should also be propagated to new files and
> directories. This way, the user's home directory would remain 0755,
> while the collaboration directory could be 0775, without any changing of
> umasks.
> 
> Of course, this would go against tradition, and cause some mayhem in the
> logic responsible for magically determining permissions for new files,
> but since we're talking about thinking outside of the box, I think
> that's excusable :)

Posix ACLs seem to solve most group permissions issues and control of
permission propegation.  It actually works quite well on Linux.  I am
surprised if there aren't lots of people already using it.

Remember that existing software expects a unix style interface, since
they are unix programs.  Anything you invent MUST be compatible with the
standard unix view of things, even if it offers additional options.

--
Len Sorensen

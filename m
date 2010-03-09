Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab0CIBuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:50:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427Ab0CIBuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:50:16 -0500
Date: Mon, 8 Mar 2010 17:49:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <20100309004829.GQ30031@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1003081742380.3669@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com>
 <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain> <20100309001554.GP30031@ZenIV.linux.org.uk> <20100309004829.GQ30031@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Mar 2010, Al Viro wrote:
> 
> BTW, if you actually look at apparmor (I'd suggest tomoyo, but I'm not _that_
> sadistic), you'll see how seriously do they take pathname-based *anything*.
> LSM hooks for namespace operations (you know, mount, umount) are lousy, but
> they exist.  Not used by apparmor.

That's a good point, btw, and shows one conceptual difference between 
content-based and pathname-based rules.

For example, if you want to log any changes to "/etc/passwd" (which is 
something pretty reasonable to do at least conceptually), what about doing 
a bind mount on top of that file?

That bind mount doesn't actually change the underlying file in any way. It 
doesn't even really _access_ it. From a content standpoint of the 
filesystem that contains the file, it's a total no-op.

But from an attack standpoint, you don't actually care, because nobody 
cares about the inode that used to be the contents of "/etc/passwd": all 
anybody _really_ cares about is "could somebody change what happens to the 
_name_ '/etc/passwd'".

But yeah, it's easy to overlook namespace changes when the obvious 
operations are read/write/unlink/rename. And I'm not at all surprised that 
people do.

			Linus

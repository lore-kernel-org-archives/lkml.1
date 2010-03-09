Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0CIALy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:11:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884Ab0CIALv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:11:51 -0500
Date: Mon, 8 Mar 2010 16:10:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rik van Riel <riel@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <4B958D7F.1030900@redhat.com>
Message-ID: <alpine.LFD.2.00.1003081555480.3669@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com>
 <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain> <4B958D7F.1030900@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Rik van Riel wrote:
> 
> > But that thing is _independent_ from the other totally unrelated issue,
> > namely the fact that "/etc/passwd" is a special name in the namespace. In
> > other words, there is "content security", but then there is also
> > "namespace security".
> 
> ... what exactly does the namespace security protect against?
> 
> What is the threat model that the namespace security protects
> against, which is not protected by the content based security?

Umm? Seriously? 

What is _any_ security all about? You try to limit the opportunity for 
damage, accidental or not.

So let's take a trivial example. Let's say that you are root, and you edit 
/etc/shadow by hand. I've done it, you've probably done it, it's not 
rocket science. Now, you do it using any random editor, and most likely 
it's going to write the new file into a temp-file, and then rename that 
temp-file over the old file (perhaps creating a backup of the old file 
depending on editor and settings).

Now, think about what that implies for a moment. Especially consider the 
case that there were ACL's ("inode-based security") on the old /etc/passwd 
or /etc/shadow file that got moved away as a backup. What happened to 
those ACL's when you edited the file using a random editor?

Now, do you see what the difference between pathname-based and inode-based 
security is? Do you realize how if anybody wants to track accesses to 
/etc/shadow, they are not going to be interested in the _old_ backup copy 
of /etc/shadow?

				Linus

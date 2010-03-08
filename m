Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0CHXi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:38:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755893Ab0CHXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:38:53 -0500
Date: Mon, 8 Mar 2010 15:37:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rik van Riel <riel@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <4B9585BD.6070904@redhat.com>
Message-ID: <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Rik van Riel wrote:
> 
> On the other hand, '/etc/shadow' has the opposite constraint,
> where the system will not trust most of the applications with
> the data from that file.

Umm. No.

/etc/shadow is in no way at all different from /etc/passwd. Both of them 
have pathname-based security issues. The fact that both of them _also_ 
have content-based security issues is an independent issue that I just 
assumed everybody would take for granted.

Clearly I assumed too much.

So I was assuming that everybody realized that the normal inode-based UNIX 
security obviously means that you can only open /etc/passwd read-only as 
any normal user (and not open /etc/shadow at all: but that is in _no_ way 
different from /etc/passwd).

That's an example of non-pathname-based security, where you actually mark 
the content itself restricted some way. It's very naturally done with 
labels on the inode itself. It's what UNIX has _always_ done

Nobody has ever suggested removing that. That would be crazy.

But that thing is _independent_ from the other totally unrelated issue, 
namely the fact that "/etc/passwd" is a special name in the namespace. In 
other words, there is "content security", but then there is also 
"namespace security". 

Of course, you can make /etc unwritable, and that is indeed the 
traditional UNIX model of handling namespace security: by just 
implementing it as "content security" of the directory.

The sgid and sticky bits can be used to further try to make it more 
fine-grained (exactly becuase it is _not_ sufficient to say "you can't 
read or write this directory" on a whole-directory basis), and obviously 
SELinux has extensions of its own too.

Can you really not see the difference between security of naming thigns 
certain things (like "/etc/passwd") - pathname based issues - and the 
separate security of limiting access to any named device - actual markings 
on the inode itself?

				Linus

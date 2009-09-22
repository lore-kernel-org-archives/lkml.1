Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZIVQEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZIVQEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZIVQEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:04:44 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45326 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbZIVQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:04:42 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 22 Sep 2009 09:04:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andreas Gruenbacher <agruen@suse.de>
cc: Jamie Lokier <jamie@shareable.org>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org
Subject: Re: fanotify as syscalls
In-Reply-To: <200909221731.34717.agruen@suse.de>
Message-ID: <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com>
References: <20090912094110.GB24709@ioremap.net> <20090921231227.GJ14700@shareable.org> <alpine.DEB.2.00.0909211816020.1116@makko.or.mcafeemobile.com> <200909221731.34717.agruen@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Andreas Gruenbacher wrote:

> The fatal flaw of syscall interception is race conditions: you look up a 
> pathname in your interception layer; then when you call into the proper 
> syscall, the kernel again looks up the same pathname. There is no way to 
> guarantee that you end up at the same object in both lookups. The security 
> and fsnotify hooks are placed in the appropriate spots to avoid exactly that.

Fatal? You mean, for this corner case that the anti-malware industry lived 
with for so much time (in Linux and Windows), you're prepared in pushing 
all the logic that is currently implemented into their modules, into the 
kernel?
This includes process whitelisting, path whitelisting, caches, userspace 
access API definition, and so on? On top of providing a generally more 
limited interception.
Why don't we instead offer a lower and broader level of interception, 
letting the users decide if such fatal flaw needs to be addressed or 
not, in their modules?
They get a broader inteception layer, with the option to decide if or if 
not address certain scenarios, and we get less code inside the kernel.
A win/win situation, if you ask me.


- Davide



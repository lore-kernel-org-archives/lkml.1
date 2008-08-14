Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYHNN7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYHNN7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbYHNN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:59:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40503 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYHNN7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:59:20 -0400
Date: Thu, 14 Aug 2008 14:54:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: tvrtko.ursulin@sophos.com
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       davecb@sun.com, Greg KH <greg@kroah.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080814125410.GA2262@elf.ucw.cz>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813135207.CC08C3765BC@pmx1.sophos.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Okay, so goal of libmalware.so is to "not allow data in the black list
to pass through Linux server". Threat model is windows machines trying
to copy infected files through the server. Viruses are not expected to
have shell access to either root or normal users on the server.

> Big snip since I am really only curious about libmalware.so.
> 
> > Plus, proposed solution already has three unacceptable holes:
> > 
> > 1) it only catches known signatures
> > 2) write vs. read race mentioned above
> 
> Discussions about perfect, better or no security are in danger of becoming 
> boring.
> 
> > 3) mmap problem
> > 
> > . Making sure all apps use libmalware.so is trivial compared to
> > solving 3).
> 
> You haven't answered what exactly is this libmalware.so, since you are the 
> only one mentioning it? It would be interesting to learn how it solves the 
> mmap problem, provides perfect security so it is acceptable, handles the 
> kernel NFS server serving malicious files, caters for applications which 
> do not use it, is better (more secure) than the kernel solution, provides 
> reasonalbe performance and is easier to maintain for the community? To 
> list only some of the requirements which have been mentioned so far.

mmap problem: libmalware.so would not offer mmap() to applications (or
maybe it would do copy of the file, then allow mmap on the copy).

kernel NFS server is not handled; don't use it for serving Windows
clients. Not that you need performance for that, anyway.

Obviously libmalware.so will not help applications not using it. With
distributions, that's not a problem.

Unlike kernel solution, it does not contain races with read/write/mmap
-- untrusted files access is made through methods that can be safe.

You can query helper daemon for cache info; that should provide good
enough performance.

I never claimed it is easier to maintain than kernel solution; but
unlike kernel solution it actually _works_, 100% of time, for apps
using it.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXFJFHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXFJFHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 01:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbXFJFHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 01:07:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbXFJFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 01:07:44 -0400
Date: Sat, 9 Jun 2007 22:06:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: dean gaudet <dean@arctic.org>
cc: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <Pine.LNX.4.64.0706092138340.10324@twinlark.arctic.org>
Message-ID: <alpine.LFD.0.98.0706092159110.20321@woody.linux-foundation.org>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706092138340.10324@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jun 2007, dean gaudet wrote:
> 
> for an example of a library wanting to cache an open fd ... and failing 
> miserably at protecting itself from the application closing its fd read:

Heh.

Why the hell doesn't that thing just do an "fstat()" on the thing, and 
compare the inode number? Not that I would guarantee that it works either 
for a socket, but it would seem to make more sense than what it apparently 
does now, and I think it should work at least on Linux.

(Ie linux will give fake "st_ino" numbers to sockets. Whether anybody else 
will do that, I have no friggin clue. And you probably shouldn't depend on 
it even under Linux, but damn, despite all of those issues, it's likely 
better and more logical than what libnss-ldap apparently does now ;)

Doing a "fstat()" call is how you generally test if two fd's point to the 
same file. Doing the same thing for sockets would at least be half-way 
sane, and even if the OS doesn't give new sockets individual st_ino 
numbers, they probably won't be *changing*.

		Linus

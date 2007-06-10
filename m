Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXFJFqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXFJFqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 01:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXFJFqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 01:46:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51859 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXFJFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 01:46:37 -0400
Date: Sun, 10 Jun 2007 06:46:28 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dean gaudet <dean@arctic.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610054628.GF21478@ftp.linux.org.uk>
References: <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org> <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org> <Pine.LNX.4.64.0706092138340.10324@twinlark.arctic.org> <alpine.LFD.0.98.0706092159110.20321@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706092159110.20321@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 10:06:27PM -0700, Linus Torvalds wrote:
> Why the hell doesn't that thing just do an "fstat()" on the thing, and 
> compare the inode number? Not that I would guarantee that it works either 
> for a socket, but it would seem to make more sense than what it apparently 
> does now, and I think it should work at least on Linux.

It works on Linux, all right.

> (Ie linux will give fake "st_ino" numbers to sockets. Whether anybody else 
> will do that, I have no friggin clue. And you probably shouldn't depend on 
> it even under Linux, but damn, despite all of those issues, it's likely 
> better and more logical than what libnss-ldap apparently does now ;)

On FreeBSD it will simply give you zero st_ino on almost all sockets;
AF_UNIX ones get st_ino invented (and stable).  st_dev is NODEV in all
cases...

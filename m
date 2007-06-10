Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbXFJRZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbXFJRZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbXFJRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:25:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760974AbXFJRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:25:09 -0400
Date: Sun, 10 Jun 2007 10:23:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: dean gaudet <dean@arctic.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070610054628.GF21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706101022180.20321@woody.linux-foundation.org>
References: <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706092138340.10324@twinlark.arctic.org>
 <alpine.LFD.0.98.0706092159110.20321@woody.linux-foundation.org>
 <20070610054628.GF21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Al Viro wrote:
> 
> On FreeBSD it will simply give you zero st_ino on almost all sockets;
> AF_UNIX ones get st_ino invented (and stable).  st_dev is NODEV in all
> cases...

So it will still work better than trying to do a "getsockname()" or 
something. If the file descriptor really _has_ been changed, it might give 
a false negative (somebody replaced it with *another* socket), but on the 
other hand, that's much better than a false positive. And if somebody 
replaced the socket with a real file descriptor, it will catch it..

		Linus

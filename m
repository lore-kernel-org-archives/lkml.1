Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbXFJEpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbXFJEpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXFJEpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:45:12 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:36287 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXFJEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:45:11 -0400
Date: Sat, 9 Jun 2007 21:45:09 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706092138340.10324@twinlark.arctic.org>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Linus Torvalds wrote:

> IOW, the most common case for libraries is not that they get invoced to do 
> one thing, but that they get loaded and then used over and over and over 
> again, and the _reason_ for wanting to have a file descriptor open may 
> well be that the library wants to cache the file descriptor, rather than 
> having to open a file over and over again!

for an example of a library wanting to cache an open fd ... and failing 
miserably at protecting itself from the application closing its fd read:

http://bugzilla.padl.com/show_bug.cgi?id=304
http://bugzilla.padl.com/show_bug.cgi?id=305

basically libnss-ldap is trying to use getsockname/getpeername to prove 
that an fd belongs to it.  the failure modes are quite delightful.

-dean

Return-Path: <linux-kernel-owner+w=401wt.eu-S1161092AbXCGHPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161092AbXCGHPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXCGHPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:15:54 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42431 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161106AbXCGHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:15:53 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 23:15:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <45EE6125.3010702@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703062312010.10398@alien.or.mcafeemobile.com>
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
 <45EE6125.3010702@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Eric Dumazet wrote:

> I would definitly *love* saving dentries for pipes (and sockets too), but how
> are you going to get the inode ?

I was not planning to touch anything but epoll, signalfd and timerfd 
files.


> pipes()/sockets() can use read()/write()/rw_verify_area() and thus need
> file->f_path.dentry->d_inode (so each pipe needs a separate dentry)

Currently, they use a single inode, and multiple dentries (to give the 
name of the class). But this could be changed to a single dentry like 
Linus was suggesting. I'll wait for Al's reply before doing anything.
Memory saving can be something, on top of the already big one of avoiding 
code duplication.



- Davide



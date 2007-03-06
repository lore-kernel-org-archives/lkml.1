Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXCFCnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXCFCnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCFCnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:43:24 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37957 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbXCFCnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:43:23 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 18:43:22 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <45ECD3D4.5020305@zytor.com>
Message-ID: <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
 <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
 <45ECD3D4.5020305@zytor.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, H. Peter Anvin wrote:

> Davide Libenzi wrote:
> > 
> > Right now is using:
> > 
> > 	this.len = sprintf(name, "[%u.%d]", current->pid, fd);
> > 
> > That should be unique and not have the wraparound problem. Ack?
> > 
> 
> NAK, very much NAK.
> 
> File descriptors aren't file structures, they're *pointers* to file
> structures.
> 
> It's perfectly possible -- downright common -- for a file descriptor to be
> inherited by another process, and then the pid is recycled -- collision.

Ugh! Right! 64 bit counter it is ... :)



- Davide



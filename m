Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXCFCeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXCFCeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbXCFCeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:34:13 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37953 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbXCFCeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:34:12 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 18:34:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <45ECD122.6020907@zytor.com>
Message-ID: <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
 <45ECD122.6020907@zytor.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, H. Peter Anvin wrote:

> Linus Torvalds wrote:
> > 
> > Since this is not actually *used* for anything but showing the fd's in
> > /proc/<pid>/fd/ etc, no. In fact, an integer will wrap a *lot* less than a
> > kernel data structure will be re-used, so even with the simple "wraps every
> > 4G uses", you're still better off.
> > 
> 
> ... and if that worries you, use a 64-bit counter.  They're cheap (compared to
> an sprintf), and even if they advance once a nanosecond they won't wrap around
> for over 584 years.

Right now is using:

	this.len = sprintf(name, "[%u.%d]", current->pid, fd);

That should be unique and not have the wraparound problem. Ack?



- Davide



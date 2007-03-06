Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbXCFCiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbXCFCiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933866AbXCFCiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:38:13 -0500
Received: from terminus.zytor.com ([192.83.249.54]:60490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933864AbXCFCiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:38:13 -0500
Message-ID: <45ECD3D4.5020305@zytor.com>
Date: Mon, 05 Mar 2007 18:37:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org> <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> 
> Right now is using:
> 
> 	this.len = sprintf(name, "[%u.%d]", current->pid, fd);
> 
> That should be unique and not have the wraparound problem. Ack?
> 

NAK, very much NAK.

File descriptors aren't file structures, they're *pointers* to file 
structures.

It's perfectly possible -- downright common -- for a file descriptor to 
be inherited by another process, and then the pid is recycled -- collision.

	-hpa

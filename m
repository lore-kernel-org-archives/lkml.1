Return-Path: <linux-kernel-owner+w=401wt.eu-S934517AbYEBUeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbYEBUeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932278AbYEBUeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:34:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765206AbYEBUeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:34:02 -0400
Date: Fri, 2 May 2008 13:33:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
In-Reply-To: <20080502202151.GB24080@logfs.org>
Message-ID: <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Jörn Engel wrote:
> 
> Currently performance sucks badly on block device flashes (usb stick,
> etc.) when creating/removing/renaming files.  The combination of logfs
> and the built-in logic can result in 1-2MB of data written to create a
> single empty file.  Yuck!

Can you talk about why, and describe these kinds of things? Is it just 
because of deep directory trees and having to rebuild the tree from the 
root up, or is it something else going on?

> Fragmentation is neither actively avoided nor actively enforced.

I was more thinking about the fragmentation in terms of how much free 
space you need for reasonable performance behavior - these kinds of things 
tend to easily start behaving really badly when the disk fills up and you 
need to GC all the time just to make room for new erase blocks for the 
trivial inode mtime/atime updates etc.

Maybe logfs doesn't have that problem for some reason, but in many cases 
there are rules like "we will consider the filesystem full when it goes 
over 90% theoretical fill", and it's interesting to know.

> I guess the above could go into Documentation/filesystems/logfs.txt.
> And some more.

I did try looking at gitweb to see if I could find some documentation 
file. I didn't find anything.

		Linus

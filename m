Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbYFAEBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYFAEBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 00:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYFAEBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 00:01:44 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:3798 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbYFAEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 00:01:43 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 00:01:43 EDT
Message-ID: <48421D65.8040301@lougher.demon.co.uk>
Date: Sun, 01 Jun 2008 04:54:13 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
References: <200805311737.58991.arnd@arndb.de> <48419F45.20908@davidnewall.com> <200805312240.50720.arnd@arndb.de>
In-Reply-To: <200805312240.50720.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Saturday 31 May 2008, David Newall wrote:
>> I don't agree that it is nicer to do this in cramfs.  I prefer the
>> technique of union of a tmpfs over some other fs because a single
>> solution that works with all filesystems is better than re-implementing
>> the same idea in multiple filesystems.  Multiple implementations is a
>> recipe for bugs and feature mismatch.
> 
> You're right in principle, but unfortunately there is to date no working
> implementation of union mounts. Giving users the option of using an
> existing file system with a few tweaks can only be better than than
> forcing them to use hacks like unionfs.
> 

I tend to agree with Arnd Bergmann.  While I prefer the aesthetic 
cleanliness of stackable filesystems, the lack of proper stacking 
support in the Linux VFS makes other techniques necessary.  Unionfs is 
complex and for many embedded systems with constrained resources Unionfs 
adds a lot of extra overhead.

If I read the patches correctly, when a file page is written to, only 
that page gets copied into the page cache and locked, the other pages 
continue to be read off disk from cramfs?  With Unionfs a page write 
causes the entire file to be copied up to the r/w tmpfs and locked into 
the page cache causing unnecessary RAM overhead.

Phillip


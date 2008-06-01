Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYFAM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYFAM2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 08:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYFAM2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 08:28:35 -0400
Received: from mail2.shareable.org ([80.68.89.115]:54108 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYFAM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 08:28:34 -0400
Date: Sun, 1 Jun 2008 13:28:18 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, David Newall <davidn@davidnewall.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Message-ID: <20080601122818.GA3687@shareable.org>
References: <200805311737.58991.arnd@arndb.de> <48419F45.20908@davidnewall.com> <200805312240.50720.arnd@arndb.de> <48421D65.8040301@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48421D65.8040301@lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> If I read the patches correctly, when a file page is written to, only 
> that page gets copied into the page cache and locked, the other pages 
> continue to be read off disk from cramfs?  With Unionfs a page write 
> causes the entire file to be copied up to the r/w tmpfs and locked into 
> the page cache causing unnecessary RAM overhead.

Ok, so why not fix that in unionfs?  An option so that holes in the
overlay file let through data from the underlying file sounds like it
would be generally useful, and quite easy to implement.

If not unionfs, a "union-tmpfs" combination would be good.  Many
filesystems aren't well suited to being the overlay filesystem -
adding to the implementation's complexity - but a modified tmpfs could
be very well suited.

-- Jamie

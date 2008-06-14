Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYFNKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYFNKLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYFNKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:11:00 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45162 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbYFNKK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:10:59 -0400
Date: Sat, 14 Jun 2008 14:10:55 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [0/3] POHMELFS high performance network filesystem. First steps in parallel processing.
Message-ID: <20080614101055.GB8857@2ka.mipt.ru>
References: <20080613163700.GA25860@2ka.mipt.ru> <485394E6.9080809@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485394E6.9080809@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 05:52:38AM -0400, Jeff Garzik (jeff@garzik.org) wrote:
> Neat :)  Thanks for protocol documentation, too.  Do you plan to add 
> write-pages in addition to write-page?  Also, write-page does not appear 
> to be documented.

->writepage() is not needed at all (it does not even exist anymore :),
and only ->writepages() is used.

> Is race-across-directories race-free?  That is a sticky area, see 
> Documentation/filesystems/directory-locking in particular.

POHMELFS relies on VFS to handle that cases, it does not invent own stuff here.
Although there is kind of a path/name cache, it is very trivial and small.

> With the exception of encryption, do you think the POHMELFS client is
> mostly complete, at this point?

I think I will extend its command structure to support checksum (i.e.
add 64bit field unused for now), all other protocol changes are supposed
to be on the highest level (like new commands), so it should not hurt others.

I have to think about locking (file locks on server, not POHMELFS internal
locking :) some more, but so far I do not see, how it can change the picture.

Another task is to move from slab allocation (kmalloc and friends) to
memory pools, like it was done for transaction destinations.

I do not plan serious changes in client (I frankly do not know, what
else I want there :), so, yes, I think that most of the client side is ready.

-- 
	Evgeniy Polyakov

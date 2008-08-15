Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYHRLA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYHRLA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYHRK7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:59:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4645 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752331AbYHRK7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:59:52 -0400
Date: Fri, 15 Aug 2008 18:06:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, tytso@mit.edu, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080815160615.GD8860@ucw.cz>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813103951.1e3e5827@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Now this to me we have a few basic building blocks:
> 1) We need an efficient mechanism to notify userspace of files that get
> dirtied. Virus scanners will subscribe to this for the async dirty
> scanning; indexing agents also will subscribe to this.

ACK.

> I think few people will disagree about this.
> 
> Open questions now are
> 4) do we have the kernel kick off an async scan in open() or do we have
> glibc do this
> 5) do we have the kernel do the sync scan on read/mmap/.. or do we have
> glibc do this


How does it work? Memory can still change after mmap; scanning at the
mmap time is _NOT_ enough.

You could do 'when app attempts to dirty memory, synchronously unmap
it from all apps that have it mapped' and then do sync scan on
pagefault time; but that sounds impractical.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

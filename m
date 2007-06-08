Return-Path: <linux-kernel-owner+w=401wt.eu-S968688AbXFHMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968688AbXFHMuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938450AbXFHMu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:50:29 -0400
Received: from THUNK.ORG ([69.25.196.29]:53541 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938296AbXFHMu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:50:27 -0400
Date: Fri, 8 Jun 2007 08:07:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608120746.GD12687@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Davide Libenzi <davidel@xmailserver.org>,
	Ulrich Drepper <drepper@redhat.com>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com> <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com> <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com> <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 03:40:14PM -0700, Davide Libenzi wrote:
> Yes. Files with the CLOFORK and CLOEXEC flag do not count for fork and 
> exec copies.
> I was also planning on doing it in __put_unused_fd(), every time 
> fmap->count goes to zero. But get_random_int() is not as cheap as I 
> thought. If we use a cheaper (although less secure) function to mix pid & 
> jiffies, we could do it even in there.

Um, how cheap do you need it?  get_random_int() is actually pretty
cheep, since it was designed to be usable by the networking stack for
sequence numbers for TCP packets; and it's not like sys_close() or
sys_open() is a majorly critical path, is it?  If the concern is
increasing the potential hold time, I suppose you could have the
exactly two callers of __put_unused_fd() (sys_close() and
put_unused_fd()) call get_random_int() before grabbing the
current->files->file_lock spinlock,

						- Ted

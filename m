Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZFGK3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZFGK3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZFGK3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:29:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38583 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbZFGK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:29:46 -0400
Date: Sun, 7 Jun 2009 12:29:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Larry H." <research@subreption.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
	ZERO_SIZE_PTR to point at unmapped space)
Message-ID: <20090607102910.GA1592@ucw.cz>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ok. So what we need to do is stop this toying around with remapping of
> page 0. The following patch contains a fix and a test program that
> demonstrates the issue.
> 
> 
> Subject: [Security] Do not allow remapping of page 0 via MAP_FIXED
> 
> If one remaps page 0 then the kernel checks for NULL pointers of various
> flavors are bypassed and this may be exploited in various creative ways
> to transfer data from kernel space to user space.

Yes, mmap() at page zero 0 makes exploits harder; and yes disabling it
may be useful (but we tried that before, see Alan's comment). But that
does not it mean it deserves _security_ label. Call it robustness or
something....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

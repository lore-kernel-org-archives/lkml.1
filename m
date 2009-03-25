Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZCYVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZCYVeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZCYVeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:34:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60457 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZCYVeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:34:00 -0400
Message-ID: <49CAA31B.7080107@garzik.org>
Date: Wed, 25 Mar 2009 17:33:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> OS X, for example, doesn't do the disk barrier. It requires you to do a 
> separate FULL_FSYNC (or something similar) ioctl to get that. Apparently 
> exactly because users don't expect quite _that_ big of a performance hit.

I can understand that, more from an admin standpoint than anything... 
ATA disks' FLUSH CACHE is horribly coarse-grained, all-or-nothing.

SCSI's SYNCHRONIZE CACHE at least gives us an optional (LBA, length) 
pair that can be used to avoid to flushing everything in the cache.

Microsoft has publicly proposed a WRITE BARRIER command for ATA, to try 
and improve the situation:
http://www.t13.org/Documents/UploadedDocuments/docs2007/e07174r0-Write_Barrier_Command_Proposal.doc

but that isn't in the field yet (if ever?)

	Jeff



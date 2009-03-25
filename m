Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZCYXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZCYXM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZCYXMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:12:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42217 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYXMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:12:49 -0400
Message-ID: <49CABA44.90004@garzik.org>
Date: Wed, 25 Mar 2009 19:12:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] issue storage device flush via sync_blockdev() (was Re:
 Linux 2.6.29)
References: <20090324132032.GK5814@mit.edu>	<alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>	<20090324184549.GE32307@mit.edu>	<alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>	<49C93AB0.6070300@garzik.org>	<20090325093913.GJ27476@kernel.dk>	<49CA86BD.6060205@garzik.org>	<20090325194341.GB27476@kernel.dk>	<49CA9346.6040108@garzik.org>	<alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>	<20090325212923.GA5620@havoc.gtf.org> <20090325220108.582a1f88@lxorguk.ukuu.org.uk>
In-Reply-To: <20090325220108.582a1f88@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This is a simple step that would cover a lot of cases...  sync(2)
>> calls sync_blockdev(), and many filesystems do as well via the generic
>> filesystem helper file_fsync (fs/sync.c).
> 
> file_fsync probably needs to pass down more information so you can make
> this a mount option. It's going to depend on the application whether the
> flush is good bad or indifferent.

file_fsync is only used by ancient legacy filesystems, who specifically 
don't want to bother with anything more complicated: HFS, HFS+, ADFS, 
AFFS, FAT, bfs, UFS, NTFS, qnx4.

IOW they _already_ consciously implement fsync(2) as "flush ENTIRE 
blockdev".

I think it is worth it to simply wait and see if mount options are even 
wanted.

	Jeff



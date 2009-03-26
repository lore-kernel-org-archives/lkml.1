Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZCZBoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZCZBoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZCZBoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:44:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52801 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbZCZBoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:44:03 -0400
Message-ID: <49CADCCC.4000902@redhat.com>
Date: Wed, 25 Mar 2009 21:39:24 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Eric Sandeen <sandeen@sandeen.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] issue storage device flush via sync_blockdev() (was Re:
 Linux 2.6.29)
References: <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <49CAA88B.1080102@sandeen.net> <49CAD343.5070009@redhat.com> <49CAD9B3.1010208@garzik.org> <49CADB55.8050400@garzik.org>
In-Reply-To: <49CADB55.8050400@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeff Garzik wrote:
>> Ric Wheeler wrote:
>> What do you think sync_blockdev() does?  What is its purpose?
>
>> Twofold:
>> (1) guarantee all user data is flushed out before a major event 
>> (unmount, journal close, unplug, poweroff, explosion, ...)
>
>> (2) As a sledgehammer hack for simple or legacy filesystems that do 
>> not wish or need the complexity of transactional protection. 
>> sync_blockdev() is intentionally used in lieu of complexity for the 
>> following filesystems: HFS, HFS+, ADFS, AFFS, FAT, bfs, UFS, NTFS, qnx4.
>
>> My patch adds needed guarantees, only for the above filesystems, 
>> where none were present before.
>
> To be specific, I was referring to fsync(2) guarantees being added to 
> HFS, HFS+, ADFS, AFFS, FAT, bfs, UFS, NTFS, and qnx4.
>
> Other filesystems, besides those in the list, gain the 
> flush-on-unmount action (a rare but useful addition) with my patch.
>
>     Jeff
>
>
>
Sorry for misunderstanding the scope of this before - this is certainly 
a net win for the file systems that don't have proper barrier support 
baked in already. Thanks!

Ric



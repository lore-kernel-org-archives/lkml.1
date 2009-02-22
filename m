Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZBVXr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZBVXr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZBVXrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:47:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40153 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZBVXrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:47:20 -0500
Message-ID: <49A1E3EB.8050708@garzik.org>
Date: Sun, 22 Feb 2009 18:46:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Pavel Machek <pavel@ucw.cz>, Eric Sandeen <sandeen@redhat.com>,
       Jan Kara <jack@suse.cz>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com> <20090213022336.GH6922@mini-me.lan> <20090222141532.GC1586@ucw.cz> <20090222231914.GI17066@mit.edu> <49A1E2D3.9000304@garzik.org>
In-Reply-To: <49A1E2D3.9000304@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Correctness should come before performance.  Linux has not had 
> credibility here, in the ATA+ext[23] space at least, and it is 
> embarrassing.


To be more clear / precise, this means actually performing the 
guarantees we claim to the user.  For example,

fsync(2) on ext2 should trigger a storage device writeback cache flush 
[or equivalent guarantee via FUA].

fsync(2) or journal commit on ext3 should trigger a flush [or equivalent 
guarantee via FUA].

Though, certainly, the user should be able to disable this strict 
behavior and trade correctness for performance.

	Jeff





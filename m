Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZATEOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZATEOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 23:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZATEOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 23:14:01 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65313 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZATEN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 23:13:59 -0500
Date: Mon, 19 Jan 2009 21:13:49 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
In-reply-to: <1232419149.19468.3.camel@norville.austin.ibm.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: coly.li@suse.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>,
       reiserfs-devel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-id: <20090120041349.GL3286@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <4974B8C4.3070703@suse.de>
 <1232393334.5893.42.camel@norville.austin.ibm.com>
 <20090119233651.GK3286@webber.adilger.int>
 <1232419149.19468.3.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 19, 2009  20:39 -0600, Dave Kleikamp wrote:
> On Tue, 2009-01-20 at 07:36 +0800, Andreas Dilger wrote:
> > The whole point of fsid (for NFS) is that this identifies the filesystem
> > over reboot, even if the block device ID changes, or if the filesystem
> > doesn't have a block device at all (e.g. cluster filesystem).
> 
> I guess that just demonstrates how little I know about what the fsid is
> about.  Would it be preferable for file systems that have a uuid to use
> that instead?  Of course anything is an improvement over zeroes.

Yes, that is what the ext* patches do - fold the 128-bit UUID into a 64-bit
fsid so that it is constant across reboots.  The chance of UUID collision
is about 1/2^32 due to birthday paradox, which is fairly low, and in case
this happens one of the filesystem UUIDs can be regenerated.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZAST3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZAST3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZAST3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:29:06 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42227 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZAST3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:29:04 -0500
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: coly.li@suse.de
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>,
       reiserfs-devel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4974B8C4.3070703@suse.de>
References: <4974B8C4.3070703@suse.de>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 13:28:54 -0600
Message-Id: <1232393334.5893.42.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches probably belong in linux-fsdevel, but I hesitate to ask
you to repost all twenty.

On Tue, 2009-01-20 at 01:30 +0800, Coly Li wrote:
> Currently many file systems in Linux kernel do not return f_fsid in statfs info, the value is set as
> 0 in vfs layer. Anyway, in some conditions, f_fsid from statfs(2) is useful, especially being used
> as (f_fsid, ino) pair to uniquely identify a file.
> 
> Basic idea of the patches is generating a unique fs ID by huge_encode_dev(sb->s_bdev->bd_dev) during
> file system mounting life time (no endian consistent issue). sb is a point of struct super_block of
> current mounted file system being accessed by statfs(2).

ext[234] return a portion of the uuid in f_fsid.  There is a theoretical
chance of those values being non-unique.  Since there doesn't appear to
be any case for the fsid to be persistent between boots, I guess
huge_encode_dev() is probably a better choice.  In practice it probably
makes no difference.

> The patches are quite simple, any feedback or patch review is welcome.

They look reasonable to me.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center


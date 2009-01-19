Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZASRZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZASRZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:25:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZASRYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:24:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:49784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZASRYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:24:50 -0500
Message-ID: <4974B8C4.3070703@suse.de>
Date: Tue, 20 Jan 2009 01:30:44 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>,
       reiserfs-devel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/20] return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently many file systems in Linux kernel do not return f_fsid in statfs info, the value is set as
0 in vfs layer. Anyway, in some conditions, f_fsid from statfs(2) is useful, especially being used
as (f_fsid, ino) pair to uniquely identify a file.

Basic idea of the patches is generating a unique fs ID by huge_encode_dev(sb->s_bdev->bd_dev) during
file system mounting life time (no endian consistent issue). sb is a point of struct super_block of
current mounted file system being accessed by statfs(2).

The patches are quite simple, any feedback or patch review is welcome.

Thanks.
-- 
Coly Li
SuSE Labs






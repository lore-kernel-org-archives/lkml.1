Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZCWPIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZCWPIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZCWPIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:08:11 -0400
Received: from THUNK.ORG ([69.25.196.29]:33498 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbZCWPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:08:09 -0400
Date: Mon, 23 Mar 2009 11:08:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Richard =?iso-8859-1?Q?H=F6chenberger?= <richard@r-selected.de>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Severe data corruption with ext4
Message-ID: <20090323150804.GG13368@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Richard =?iso-8859-1?Q?H=F6chenberger?= <richard@r-selected.de>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20090320030121.1fa8e6d3.akpm@linux-foundation.org> <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com> <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com> <20090323020522.GF29466@mit.edu> <b2080d80903230210w60d48530n9b98fdf71cf6fd18@mail.gmail.com> <20090323121709.GD13368@mit.edu> <b2080d80903230720m16af65c4t992b9cc34c44b914@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2080d80903230720m16af65c4t992b9cc34c44b914@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 03:20:03PM +0100, Richard Höchenberger wrote:
> Hi Ted, I just compiled and installed 2.6.29-rc8 vanilla. Before
> running it, I booted from a live CD and fsck'd all my file systems to
> get them into a consistent, clean state.
> 
> Now, after booting 2.6.29-rc8 and writing stuff to dm-14 (/usr), I again get:
> 
> ----------
> Mar 23 15:01:02 bakunin kernel: __find_get_block_slow() failed.
> block=135274289954816, b_blocknr=0
> Mar 23 15:01:02 bakunin kernel: b_state=0x00310021, b_size=4096
> Mar 23 15:01:02 bakunin kernel: device blocksize: 4096
> Mar 23 15:01:02 bakunin kernel: __find_get_block_slow() failed.
> block=135274289954816, b_blocknr=0
> Mar 23 15:01:02 bakunin kernel: b_state=0x00310021, b_size=4096
> Mar 23 15:01:02 bakunin kernel: device blocksize: 4096
> Mar 23 15:01:02 bakunin kernel: grow_buffers: requested out-of-range
> block 135274289954816 for device dm-14
> Mar 23 15:01:02 bakunin kernel: EXT4-fs error (device dm-14):
> ext4_xattr_delete_inode: inode 4501: block 135274289954816 read error
> ----------

Hmm, so the block number is: 7B0800000000 that indicats that
i_file_acl is 0, but the bits in i_file_acl_high are set.  E2fsck
doesn't currently detect and fix this case --- which is a bug in
e2fsck that I'll fix --- but it begs the question how the
i_file_acl_high could have gotten set in the first place.

Was this a freshly created ext4 filesystem, or one that was converted
from ext3?

					- Ted

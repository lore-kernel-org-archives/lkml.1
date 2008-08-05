Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbYHEDJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbYHEDJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYHEDJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:09:21 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:14091 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbYHEDJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:09:20 -0400
Date: Tue, 05 Aug 2008 12:09:09 +0900 (JST)
Message-Id: <20080805.120909.139657748.nemoto@toshiba-tops.co.jp>
To: viro@ZenIV.linux.org.uk
Cc: djohnson@sw.starentnetworks.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: cramfs and named-pipe
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080804100347.GU28946@ZenIV.linux.org.uk>
References: <20080804.182143.218269280.nemoto@toshiba-tops.co.jp>
	<20080804100347.GU28946@ZenIV.linux.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 11:03:47 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> Eeek...  I'd rather not play these games with directories and devices nodes
> as well.  Rationale for the original patch simply doesn't apply for those.
> 
> IOW, I think it would be much saner if we did the following: make ..._test()
> refuse to merge inodes with ->i_ino == 1, take inode setup back to
> get_cramfs_inode() and make ->drop_inode() evict ones with ->i_ino == 1
> immediately.  Comments?
> 
> Patch below is completely untested; it builds, but that's it.

Thanks, your patch works well for me.  But it looks a bit large for
stable tree (100 line rule).

With current code, I think no problem on empty directories and device
nodes.  So how about fixing only FIFO case first (and send it to
stable tree) and then go to your patch?

---
Atsushi Nemoto

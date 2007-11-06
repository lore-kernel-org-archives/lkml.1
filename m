Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXKFRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXKFRmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXKFRmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:42:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXKFRl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:41:59 -0500
Date: Tue, 6 Nov 2007 09:40:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Message-ID: <20071106094056.3352a574@laptopd505.fenrus.org>
In-Reply-To: <20071106171945.GG23689@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz>
	<20071106171945.GG23689@duck.suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 18:19:45 +0100
Jan Kara <jack@suse.cz> wrote:

> Implement recursive mtime (rtime) feature for ext3. The feature works
> as follows: In each directory we keep a flag EXT3_RTIME_FL
> (modifiable by a user) whether rtime should be updated. In case a
> directory or a file in it is modified and when the flag is set,
> directory's rtime is updated, the flag is cleared, and we move to the
> parent. If the flag is set there, we clear it, update rtime and
> continue upwards upto the root of the filesystem. In case a regular
> file or symlink is modified, we pick arbitrary of its parents
> (actually the one that happens to be at the head of i_dentry list)
> and start the rtime update algorith there.

Ok since mtime (and rtime) are part of the inode and not the dentry...
how do you deal with hardlinks? And with cases of files that have been
unlinked? (ok the later is a wash obviously other than not crashing)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

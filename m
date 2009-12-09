Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZLIC0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZLIC0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 21:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZLIC0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 21:26:23 -0500
Received: from thunk.org ([69.25.196.29]:38426 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZLIC0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 21:26:22 -0500
Date: Tue, 8 Dec 2009 21:26:22 -0500
From: tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] ext4: Fix data / filesystem corruption when write
 fails to copy data
Message-ID: <20091209022622.GX27692@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
 <1259781409-31318-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259781409-31318-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 08:16:48PM +0100, Jan Kara wrote:
> When ext4_write_begin fails after allocating some blocks or
> generic_perform_write fails to copy data to write, we truncate blocks already
> instantiated beyond i_size. Although these blocks were never inside i_size, we
> have to truncate pagecache of these blocks so that corresponding buffers get
> unmapped. Otherwise subsequent __block_prepare_write (called because we are
> retrying the write) will find the buffers mapped, not call ->get_block, and
> thus the page will be backed by already freed blocks leading to filesystem and
> data corruption.

Added to the ext4 patch queue.

						- Ted

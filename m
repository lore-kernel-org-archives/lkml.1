Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbZBEUXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbZBEUXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbZBEUXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:23:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758681AbZBEUXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:23:15 -0500
Date: Thu, 5 Feb 2009 12:22:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       snakebyte@gmx.de, sliedes@cc.hut.fi, phillip@lougher.demon.co.uk
Subject: Re: [PATCH] Squashfs: Fix oops when reading fsfuzzer corrupted
 filesystems
Message-Id: <20090205122215.adcd18db.akpm@linux-foundation.org>
In-Reply-To: <E1LUY7A-0006q4-LB@dylan.lougher.demon.co.uk>
References: <E1LUY7A-0006q4-LB@dylan.lougher.demon.co.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 03:07:48 +0000
Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> -	ERROR("sb_bread failed reading block 0x%llx\n", cur_index);
> +	ERROR("squashfs_read_data failed to read block 0x%llx\n", index);

`index' has type u64.  You don't know what C type is used to implement
u64, hence it must be cast to a known type before it can be passed to
printk.

In this case we use `unsigned long long'.

The code as it stands will generate compiler warnings on some
architectures.

One day, maybe before we all die, we will fix this.  Then we get to
spend another five years weeding out all the casts we added.


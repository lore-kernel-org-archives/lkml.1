Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZB1OkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZB1OkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 09:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZB1OkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 09:40:06 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:43902 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZB1OkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 09:40:06 -0500
Date: Sat, 28 Feb 2009 08:39:43 -0600
From: David Fries <david@fries.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reorder ext4 and ext2 so that ext2 root filesystems
	are mounted using ext2
Message-ID: <20090228143943.GD4894@spacedout.fries.net>
References: <1235831060-10086-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235831060-10086-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 28 Feb 2009 08:39:45 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 09:24:20AM -0500, Theodore Ts'o wrote:
> It's doubtful that there are that many ext2-only root filesystem users
> that would also have ext4 compiled into the kernel, but to adhere to
> the principle of least surprise, the correct ordering in fs/Makefile
> is ext3, followed by ext2, and finally ext4.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> -obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4
> +obj-$(CONFIG_EXT2_FS)		+= ext2/
> +# We place ext4 after ext2 so plain ext2 root fs's are mounted using ext4
> +# unless explicitly requested by rootfstype
> +obj-$(CONFIG_EXT4_FS)		+= ext4/

Try
> +# We place ext4 after ext2 so plain ext2 root fs's aren't mounted using ext4
> +# unless explicitly requested by rootfstype

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

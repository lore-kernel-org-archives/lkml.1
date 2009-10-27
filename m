Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZJ0CPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZJ0CPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZJ0CPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:15:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZJ0CPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:15:00 -0400
Date: Mon, 26 Oct 2009 22:14:26 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 15/41] whiteout: ext2 whiteout support
Message-ID: <20091027021426.GA14574@shell>
References: <1256152779-10054-8-git-send-email-vaurora@redhat.com> <1256152779-10054-9-git-send-email-vaurora@redhat.com> <1256152779-10054-10-git-send-email-vaurora@redhat.com> <1256152779-10054-11-git-send-email-vaurora@redhat.com> <1256152779-10054-12-git-send-email-vaurora@redhat.com> <1256152779-10054-13-git-send-email-vaurora@redhat.com> <1256152779-10054-14-git-send-email-vaurora@redhat.com> <1256152779-10054-15-git-send-email-vaurora@redhat.com> <1256152779-10054-16-git-send-email-vaurora@redhat.com> <1983FB3A-C88F-4EF4-A2E1-8B18DF97F0AB@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1983FB3A-C88F-4EF4-A2E1-8B18DF97F0AB@sun.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 03:17:38PM -0600, Andreas Dilger wrote:
> On 2009-10-21, at 13:19, Valerie Aurora wrote:
> >This patch adds whiteout support to EXT2. A whiteout is an empty  
> >directory
> >entry (inode == 0) with the file type set to EXT2_FT_WHT. Therefore it
> >allocates space in directories. Due to being implemented as a  
> >filetype it is
> >necessary to have the EXT2_FEATURE_INCOMPAT_FILETYPE flag set.
> >
> >diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> >index 121720d..bd10826 100644
> >--- a/include/linux/ext2_fs.h
> >+++ b/include/linux/ext2_fs.h
> >@@ -189,6 +189,7 @@ struct ext2_group_desc
> >+#define EXT2_OPAQUE_FL			0x00040000
> 
> Please check in the upstream e2fsprogs ext2_fs.h before defining new  
> flag
> values for ext2/3/4.  In this case, 0x40000 conflicts with  
> EXT4_HUGE_FILE_FL,
> which is of course bad.
> 
> 
> >@@ -503,10 +504,12 @@ struct ext2_super_block {
> >#define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
> >+#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
> 
> This one doesn't conflict, probably due to luck, because 0x0040-0x0200  
> are
> already in use for other features.  I'm not sure if 0x0020 was  
> reserved for
> some other use, or just skipped to avoid potential conflicts.

Thanks for reviewing!  I'll fix that in the next rev.

-VAL

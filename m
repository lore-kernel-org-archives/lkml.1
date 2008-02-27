Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbYB0VGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbYB0VGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYB0VGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:06:07 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:35106 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYB0VGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:06:06 -0500
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>
	<adabq62yx5r.fsf@cisco.com>
	<Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 13:05:55 -0800
In-Reply-To: <Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com> (Davide Libenzi's message of "Wed, 27 Feb 2008 12:30:55 -0800 (PST)")
Message-ID: <ada7igqyurw.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 21:05:56.0316 (UTC) FILETIME=[8B8089C0:01C87984]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=49be4f8114e6ff0efdab10ebba2493fb67bc3034
 > 
 > I'm fine with both approaches.

Both ways are OK with me too, although Al's change leaves the trap in
the anon_inode_getfd() in that all users have to keep in mind the race
against close() from another thread.  Also Al's change moves all
documentation to __anon_inode_getfd() and leaves anon_inode_getfd()
undocumented, which is a little suboptimal.

With Al's change the 2/2 patch would have to change uverbs to use the
__anon_inode_getfd() variant and change the fd_install() in uverbs to
use fput().  If there is consensus that Al's patch will be merged for
2.6.26 I will write that patch and send it to Al to merge via his
tree, so that get_empty_filp() can be unexported.

 - R.

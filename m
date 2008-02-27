Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYB0TWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYB0TWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYB0TWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:22:11 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:52303
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbYB0TWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:22:10 -0500
Message-ID: <47C5B7E5.6030708@qumranet.com>
Date: Wed, 27 Feb 2008 21:20:05 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       kvm-devel@lists.sourceforge.net, akpm@linux-foundation.org
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
In-Reply-To: <adak5kqyzv1.fsf@cisco.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> The anonymous inodes interface anon_inode_getfd() calls fd_install()
> for the newly created fd, which does not work for some use cases where
> the caller must do futher initialization before exposing the file to
> userspace.  This is also probably not the safest interface, since the
> caller must be sure that it is OK if userspace closes the fd before
> anon_inode_getfd() even returns.
>
> Therefore, change the anonymous inodes interface so that the caller is
> responsible for calling fd_install(), and change the name of the
> function from anon_inode_getfd() to anon_inode_allocfd() so that any
> code using the old interface breaks at compilation rather than failing
> in a strange way.  Fix up all the in-kernel users to use the new
> interface.
>
>   

The kvm changes are

Acked-by: Avi Kivity <avi@qumranet.com>


-- 
Any sufficiently difficult bug is indistinguishable from a feature.


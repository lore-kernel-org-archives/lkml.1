Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbYCFPOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbYCFPOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbYCFPOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:14:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbYCFPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:14:36 -0500
Date: Thu, 6 Mar 2008 15:14:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
Message-ID: <20080306151430.GD27894@ZenIV.linux.org.uk>
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak5kqyzv1.fsf@cisco.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:16:02AM -0800, Roland Dreier wrote:
> The anonymous inodes interface anon_inode_getfd() calls fd_install()
> for the newly created fd, which does not work for some use cases where
> the caller must do futher initialization before exposing the file to
> userspace.  This is also probably not the safest interface, since the
> caller must be sure that it is OK if userspace closes the fd before
> anon_inode_getfd() even returns.

IMO that's a bad idea - majority of callers only care about fd and burdening
them with fd_install() is simply wrong.  Separate helper function...

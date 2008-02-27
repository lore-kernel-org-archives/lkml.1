Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYB0Tlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYB0Tlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbYB0Tl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:41:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40855 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbYB0TlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:41:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Feb 2008 11:41:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Roland Dreier <rdreier@cisco.com>
cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from
 anon_inode_getfd()
In-Reply-To: <adak5kqyzv1.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC-ing Al too]


On Wed, 27 Feb 2008, Roland Dreier wrote:

> The anonymous inodes interface anon_inode_getfd() calls fd_install()
> for the newly created fd, which does not work for some use cases where
> the caller must do futher initialization before exposing the file to
> userspace.  This is also probably not the safest interface, since the
> caller must be sure that it is OK if userspace closes the fd before
> anon_inode_getfd() even returns.

I believe Al changed the interface to not give out inode* and file*, *and* 
call fd_install() inside it. I'd slightly prefer Al version, although I 
don't see any major problems in this one too.



- Davide



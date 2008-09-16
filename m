Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYIPQgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYIPQgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYIPQgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:36:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYIPQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:36:07 -0400
Date: Tue, 16 Sep 2008 12:36:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@coritel.it>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: added better file aio_read aio_write operations
	presence check
Message-ID: <20080916163603.GA13049@infradead.org>
References: <48CF7C85.1070309@coritel.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CF7C85.1070309@coritel.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 11:29:41AM +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> If a filesystem in the file operations specifies for read and write operations only do_sync_read and do_sync_write without 
> init aio_read and aio_write, there will be a kernel oops, because the vfs code check the presence of (to read for example)
> read OR aio_read method, then it calls read if it's pointer is not null. It's not sufficient because if the read function is 
> actually a do_sync_read, it calls aio_read but without checking the presence. I think a BUG_ON check can be more useful.

A NULL pointer derference is just as clear as the bug..


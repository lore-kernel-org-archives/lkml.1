Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbXJGKAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbXJGKAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 06:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXJGJ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 05:59:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbXJGJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 05:59:56 -0400
Date: Sun, 7 Oct 2007 10:59:55 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hch@lst.de
Subject: Re: [patch 9/9] compat_ioctl: fix compat_fd_ioctl pointer access
Message-ID: <20071007095955.GR8181@ftp.linux.org.uk>
References: <20071006181902.141862534@arndb.de> <20071006182343.857595918@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006182343.857595918@arndb.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 08:19:11PM +0200, Arnd Bergmann wrote:
> As found by sparse, a user space pointer is assigned to a kernel
> data structure while calling other code with set_fs(KERNEL_DS),
> which could lead to leaking kernel data if that pointer is
> ever accessed.
> 
> I could not find any place in the floppy drivers that actually
> uses that pointer, but assigning it to an empty string is
> a safer choice and gets rid of the sparse warning.

FWIW, I'd kill kmalloc(), switched to compat_alloc_user_space() and
copy_in_user() / get_user()+put_user().  And kill set_fs() around that
sys_ioctl()...  Separate from the rest of this series, though.

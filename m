Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbXJGJx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbXJGJx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 05:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXJGJxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 05:53:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXJGJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 05:53:50 -0400
Date: Sun, 7 Oct 2007 10:53:48 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hch@lst.de
Subject: Re: [patch 8/9] compat_ioctl: call disk->fops->compat_ioctl without BKL
Message-ID: <20071007095348.GQ8181@ftp.linux.org.uk>
References: <20071006181902.141862534@arndb.de> <20071006182343.694115455@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006182343.694115455@arndb.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 08:19:10PM +0200, Arnd Bergmann wrote:
> Normally, all compat_ioctl operations are called without the BKL, the
> block device operations are an exception to this rule.
> 
> Make this work the same as the other handlers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> It would be good to find out whether it has been using the BKL
> on purpose or by accident, before this patch gets applied.

Leave it alone, for now - I'm rebasing my series on top of your 1--7
and it will both makes ->ioctl() and ->compat_ioctl() called unlocked
and switches ->compat_ioctl() to passing bdev instead of struct file
(->unlocked_ioctl() simply dies).

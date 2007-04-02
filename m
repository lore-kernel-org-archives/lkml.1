Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXDBGum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXDBGum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933962AbXDBGum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:50:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51478 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbXDBGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:50:11 -0400
Date: Mon, 2 Apr 2007 09:50:09 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Rene Herman <rene.herman@gmail.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <46104954.50608@gmail.com>
Message-ID: <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> 
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Rene Herman wrote:
> +       if (!blk_fs_request(req)) {
> +               spin_lock_irq(q->queue_lock);

Contrary to what I said, this spin_lock_irq() is wrong...

> +               end_request(req, 0);
> +               goto again;
> +       }
> +
> +       spin_unlock_irq(q->queue_lock);

...because we drop the lock here.

			Pekka

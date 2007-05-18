Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbXERVEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbXERVEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXERVEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:04:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbXERVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:04:31 -0400
Date: Fri, 18 May 2007 14:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Misc: phantom, move to unlocked_ioctl
Message-Id: <20070518140314.4cabb926.akpm@linux-foundation.org>
In-Reply-To: <20644182862815412171@wsc.cz>
References: <20644182862815412171@wsc.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 22:34:53 +0200 (CEST)
Jiri Slaby <jirislaby@gmail.com> wrote:

> @@ -118,7 +125,9 @@ static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
>  		if (r.reg > 7)
>  			return -EINVAL;
>  
> +		spin_lock(&dev->ioctl_lock);
>  		r.value = ioread32(dev->iaddr + r.reg);
> +		spin_unlock(&dev->ioctl_lock);

What is that locking protecting in here?

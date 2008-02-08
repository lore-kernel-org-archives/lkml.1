Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYBHWFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYBHWFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYBHWFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:05:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbYBHWFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:05:23 -0500
Date: Fri, 8 Feb 2008 14:02:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: jens.axboe@oracle.com, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-Id: <20080208140244.c850a5d3.akpm@linux-foundation.org>
In-Reply-To: <47ACC835.4070102@steeleye.com>
References: <47AC87AE.9040408@steeleye.com>
	<20080208093341.b4d02e22.randy.dunlap@oracle.com>
	<20080208101151.935b575c.akpm@linux-foundation.org>
	<47ACA250.1010404@steeleye.com>
	<20080208204510.GD23197@kernel.dk>
	<20080208204713.GF23197@kernel.dk>
	<47ACC835.4070102@steeleye.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 16:23:01 -0500
Paul Clements <paul.clements@steeleye.com> wrote:

> --- ./drivers/block/nbd.c.max_nbd_killed	2008-02-07 16:46:24.000000000 -0500
> +++ ./drivers/block/nbd.c	2008-02-08 16:13:01.000000000 -0500
> @@ -667,6 +667,12 @@ static int __init nbd_init(void)
>  			put_disk(disk);
>  			goto out;
>  		}
> +		if (elevator_init(disk->queue, "deadline") != 0) {
> +			if (elevator_init(disk->queue, "noop") != 0) {
> +				put_disk(disk);
> +				goto out;
> +			}
> +		}
>  	}

- if the user doesn't have deadline or noop configured, NBD will now
  fail.  That's a non-backward-compatible change.

- when it fails, it will fail silently.  Puzzled and angry users.

- when it fails, it will inappropriately return -ENOMEM.

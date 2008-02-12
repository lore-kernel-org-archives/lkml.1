Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYBLXRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYBLXRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYBLXQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:16:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbYBLXQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:16:49 -0500
Date: Tue, 12 Feb 2008 15:16:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: jens.axboe@oracle.com, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-Id: <20080212151602.f1803ef0.akpm@linux-foundation.org>
In-Reply-To: <47ADAB00.90306@steeleye.com>
References: <47AC87AE.9040408@steeleye.com>
	<20080208093341.b4d02e22.randy.dunlap@oracle.com>
	<20080208101151.935b575c.akpm@linux-foundation.org>
	<47ACA250.1010404@steeleye.com>
	<20080208204510.GD23197@kernel.dk>
	<20080208204713.GF23197@kernel.dk>
	<47ACC835.4070102@steeleye.com>
	<20080208140244.c850a5d3.akpm@linux-foundation.org>
	<47ADAB00.90306@steeleye.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Feb 2008 08:30:40 -0500
Paul Clements <paul.clements@steeleye.com> wrote:

> +		old_e = disk->queue->elevator;
> +		if (elevator_init(disk->queue, "deadline") == 0 ||
> +			elevator_init(disk->queue, "noop") == 0) {
> +				elevator_exit(old_e);
> +		}
>  	}

afacit elevator_init() will not trigger a request_module().  And you really
do want to trigger the request_module() here.  Perhaps the block layer
should provide a means of doing so?


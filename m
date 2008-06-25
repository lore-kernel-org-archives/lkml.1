Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYFYWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYFYWjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYFYWjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:39:31 -0400
Received: from vena.lwn.net ([206.168.112.25]:53236 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYFYWja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:39:30 -0400
Date: Wed, 25 Jun 2008 16:39:28 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] rtc: remove BKL for ioctl()
Message-ID: <20080625163928.4da1f4a0@bike.lwn.net>
In-Reply-To: <200806221955.42597.david-b@pacbell.net>
References: <200806221955.42597.david-b@pacbell.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 19:55:42 -0700
David Brownell <david-b@pacbell.net> wrote:

> Remove implicit use of BKL in ioctl() from the RTC framework.

Looks good, I'll happily put it into the bkl-removal tree.  One
question, though:

> +	err = mutex_lock_interruptible(&rtc->ops_lock);
> +	if (err)
> +		return -EBUSY;
> +

Shouldn't that be -EINTR?

Thanks,

jon

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYCST2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYCST2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYCSTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:25:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:10100 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYCSTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:46 -0400
Subject: Re: [PATCH] de-semaphorize smackfs
From: Daniel Walker <dwalker@mvista.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <30338.1205795680@vena.lwn.net>
References: <30338.1205795680@vena.lwn.net>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 08:41:39 -0700
Message-Id: <1205854899.10894.134.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 17:14 -0600, Jonathan Corbet wrote:

> @@ -171,7 +171,7 @@ static int smk_open_load(struct inode *inode, struct file *file)
>  	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
>  		return seq_open(file, &load_seq_ops);
>  
> -	if (down_interruptible(&smack_write_sem))
> +	if (mutex_lock_interruptible(&smack_write_mutex))
>  		return -ERESTARTSYS;
>  
>  	return 0;

There's a disconnect between the lock unlock calls, when the locking
application returns to userspace. Mutex's have a restriction that you
can't return to userspace while holding the lock.

Daniel


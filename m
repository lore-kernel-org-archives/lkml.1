Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbYESXwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbYESXwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbYESXvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:51:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbYESXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:51:54 -0400
Date: Mon, 19 May 2008 16:51:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA over Ethernet: Convert emsgs_sema in a completion
Message-Id: <20080519165122.9d94cc1c.akpm@linux-foundation.org>
In-Reply-To: <20080516191133.GI24569@traven>
References: <20080516191133.GI24569@traven>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 21:11:33 +0200
Matthias Kaehlcke <matthias@kaehlcke.net> wrote:

> @@ -216,7 +217,7 @@ aoechr_read(struct file *filp, char __user *buf, size_t cnt, loff_t *off)
>  
>  		spin_unlock_irqrestore(&emsgs_lock, flags);
>  
> -		n = down_interruptible(&emsgs_sema);
> +		n = wait_for_completion_interruptible(&emsgs_comp);

Patch looks OK, but I worry about this code.  Suppose a signal is sent
and we return to userspace with the complete() still outstanding.  Then
someone removes the module.  

Perhaps there is synchronisation code which prevents that crash?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYLLRA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYLLRA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYLLRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:00:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33135 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbYLLRAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:00:17 -0500
Date: Fri, 12 Dec 2008 16:59:48 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212165948.GA5774@flint.arm.linux.org.uk>
Mail-Followup-To: Gerd Hoffmann <kraxel@redhat.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 03:00:40PM +0100, Gerd Hoffmann wrote:
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 969a6d9..89f273d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -701,6 +701,54 @@ sys_writev(unsigned long fd, const struct iovec __user *vec, unsigned long vlen)
>  	return ret;
>  }
>  
> +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
> +                              unsigned long vlen, loff_t pos)

For ARM, I'd prefer this to be:

	unsigned long fd, const struct iovec __user *vec,
		loff_t pos, unsigned long vlen

to avoid any variance in ABIness which will occur with the argument
layout as it currently stands, but that creates a silly argument
order.  The other option would be for us to define our own version
in an ARM ABI independent manner:

ssize_t sys_arm_preadv(unsigned long fd, const struct iovec __user *vec,
	unsigned long vlen, unsigned long low_pos, unsigned long high_pos)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbYHIKGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbYHIKGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 06:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYHIKGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 06:06:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49668 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYHIKGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 06:06:02 -0400
Date: Sat, 9 Aug 2008 11:05:27 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix watchdog/wdt285.c compilation
Message-ID: <20080809100526.GB18510@flint.arm.linux.org.uk>
References: <20080808160346.GE14495@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808160346.GE14495@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 07:03:46PM +0300, Adrian Bunk wrote:
> wdt285.c:211: error: 'KERN_WARN' undeclared (first use in this function)

It might be worth having the kernel provide an alias for KERN_WARN
to avoid these kinds of errors in the future.  Many people have
said that they make this mistake as well, I certainly have many a
time.

The problem is that we have things like KERN_ERR, KERN_CRIT rather
than KERN_ERROR and KERN_CRITICAL, but so we think "oh, we're using
shortened versions" but then you come to KERN_WARNING rather than
KERN_WARN.

However, since xxx_WARNING is a recognised name for the severity
level (see syslog(3)) we shouldn't get rid of that.

Needless to say, this fix for wdt285 still needs to get to Linus ASAP.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

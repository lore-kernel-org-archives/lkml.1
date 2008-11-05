Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYKESYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYKESYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYKESYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:24:07 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53702 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYKESYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:24:06 -0500
Date: Wed, 5 Nov 2008 10:23:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How do I printk <type> correctly?
Message-Id: <20081105102335.b1fd995d.randy.dunlap@oracle.com>
In-Reply-To: <20081023114133.GA30187@x200.localdomain>
References: <20081023114133.GA30187@x200.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 15:41:33 +0400 Alexey Dobriyan wrote:

> If variable is of Type	use	printk format specifier.
> ---------------------------------------------------------
> 		int			%d or %x
> 		unsigned int		%u or %x
> 		long			%ld ot %lx
> 		unsigned long		%lu or %lx
> 		long long		%lld or %llx
> 		unsigned long long	%llu or %llx
> 		size_t			%zu or %zx
> 		ssize_t			%zd or %zx

Add, or is this one too infrequent to be listed here?

		tcflag_t		%lu or %lx or %lo

Since tcflag_t is unsigned int (on most $ARCH-es) or unsigned long (on sparc32),
use a cast to (unsigned long)flag when printing it.

[Yes, a sparc32 build gets lots of printk format warnings when printing tcflag_t
values.]


> Raw pointer value SHOULD be printed with %p.
> 
> u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> 
> 	printk("%llu", (unsigned long long)u64_var);
> 
> s64 SHOULD be printed with %lld/%llx, (long long):
> 
> 	printk("%lld", (long long)s64_var);
> 
> If type is dependent on config option (sector_t), use format specifier
> of biggest type and explicitly cast to it.
> 
> Reminder: sizeof() result is of type size_t.
> 
> Thank you for your cooperation.
> --

---
~Randy

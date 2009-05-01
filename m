Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZEAKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZEAKWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZEAKWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:22:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33426 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZEAKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:22:22 -0400
Date: Fri, 1 May 2009 11:22:06 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/27] asm-generic: add a NOMMU uaccess.h
Message-ID: <20090501102206.GA22387@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	Michal Simek <monstr@monstr.eu>,
	Remis Lima Baima <remis.developer@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:31:03PM +0100, Arnd Bergmann wrote:
> +#define put_user(x, ptr) (				\
> +	access_ok(VERIFY_WRITE, ptr, sizeof (*ptr)) ?	\
> +		__put_user(x, ptr) :			\
> +		-EFAULT)
> +
> +#ifndef __get_user
> +#define __get_user(x, ptr)				\
> +({							\
> +	int __gu_err = 0;				\
> +	unsigned long __gu_val = (unsigned long)*ptr;	\
> +	switch (sizeof(*(ptr))) {			\
> +	case 1:						\
> +	case 2:						\
> +	case 4:						\
> +	case 8:						\
> +		break;					\

If sizeof(unsigned long) = 4, then how can the sizeof(*(ptr)) > 4 case
work?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

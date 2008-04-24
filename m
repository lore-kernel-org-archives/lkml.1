Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYDXCYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYDXCYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYDXCYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:24:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYDXCYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:24:16 -0400
Date: Wed, 23 Apr 2008 19:24:18 -0700 (PDT)
Message-Id: <20080423.192418.188020745.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] linux/atm_tcp.h: cleanup for userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <1208661754-3197-1-git-send-email-vapier@gentoo.org>
References: <1208661754-3197-1-git-send-email-vapier@gentoo.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 19 Apr 2008 23:22:34 -0400

> The atm_tcp.h uses types from linux/atm.h, but does not include it.  It
> should also use the standard __u## types from linux/types.h rather than the
> uint##_t types since the former can be found with the kernel already.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

I don't think this is a sufficient patch to solve these problems.

> @@ -8,10 +8,8 @@
>  #define LINUX_ATM_TCP_H
>  
>  #include <linux/atmapi.h>
> -
> -#ifdef __KERNEL__
>  #include <linux/types.h>
> -#endif
> +#include <linux/atm.h>
>  #include <linux/atmioc.h>
>  
>  

So you're adding linux/atm.h as an include for non-kernel, fine,
but:

> @@ -20,9 +18,9 @@
>   */
>  
>  struct atmtcp_hdr {
> -	uint16_t	vpi;
> -	uint16_t	vci;
> -	uint32_t	length;		/* ... of data part */
> +	__u16	vpi;
> +	__u16	vci;
> +	__u32	length;		/* ... of data part */
>  };
>  
>  /*

Well, linux/atm.h, which we'll now get, has the same exact problem,
it uses "uint16_t" and related types.

Futehermore, nothing in the include chain will get linux/types.h
include, which we'll need.  linux/atm.h protects the inclusion
of linux/types.h with __KERNEL__.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764917AbXFAU4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764917AbXFAU4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763223AbXFAUzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:55:51 -0400
Received: from gw.goop.org ([64.81.55.164]:56050 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763052AbXFAUzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:55:50 -0400
Message-ID: <466087CF.70708@goop.org>
Date: Fri, 01 Jun 2007 13:55:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> ....
> +Field name:	hardware_subarch
> +Type:		write
> +Offset/size:	0x23c/4
> +Protocol:	2.07+
> +
> +  In a paravirtualized environment the hardware low level architectural 
> +  pieces such as interrupt handling, page table handling, and
> +  accessing process control registers needs to be done differently.
> +
> +  This field allows the bootloader to inform the kernel we are in one
> +  one of those environments.
> +
> +  0x00000000	The default x86/PC environment
> +  0x00000001	lguest
> +  0x00000002	Xen
> +
> +Field name:	hardware_subarch_data
> +Type:		write
> +Offset/size:	0x23c/8
>   

offset = 240

> +Protocol:	2.07+
> +
> +  A pointer to data that is specific to hardware subarch
>   

Do we care particularly? If 8 bytes is enough for the subarch, do we
care whether its a pointer or literal? After all, this is just a private
channel between the bootloader and some subarch-specific piece of code
in the kernel.

J

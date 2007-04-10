Return-Path: <linux-kernel-owner+w=401wt.eu-S966091AbXDJFX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966091AbXDJFX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 01:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966096AbXDJFX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 01:23:58 -0400
Received: from gw.goop.org ([64.81.55.164]:39728 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966091AbXDJFX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 01:23:57 -0400
Message-ID: <461B1F65.6090104@goop.org>
Date: Mon, 09 Apr 2007 22:23:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/10] I386 sysenter arch pages fix.patch
References: <200704100006.l3A062AL020596@zach-dev.vmware.com>
In-Reply-To: <200704100006.l3A062AL020596@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> In compat mode, the return value here was uninitialized.
>
> Signed-off-by: Zachary Amsden <zach@vmware.com>
>
> diff -r 1fda49a076ed arch/i386/kernel/sysenter.c
> --- a/arch/i386/kernel/sysenter.c	Fri Apr 06 14:25:09 2007 -0700
> +++ b/arch/i386/kernel/sysenter.c	Fri Apr 06 14:27:31 2007 -0700
> @@ -254,7 +254,7 @@ int arch_setup_additional_pages(struct l
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long addr;
> -	int ret;
> +	int ret = 0;
>  	bool compat;
>  
>  	down_write(&mm->mmap_sem);
> -

Hm, OK, but what about just zeroing it in the compat leg of the if()?

    J

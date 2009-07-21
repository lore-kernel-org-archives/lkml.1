Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbZGUS2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbZGUS2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZGUS2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:28:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZGUS2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:28:22 -0400
Message-ID: <4A660891.7070105@zytor.com>
Date: Tue, 21 Jul 2009 11:27:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ia32: strncpy does not null terminate string
References: <4A60755F.4030604@gmail.com>
In-Reply-To: <4A60755F.4030604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> 
> diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
> index 085a8c3..b114f57 100644
> --- a/arch/x86/ia32/sys_ia32.c
> +++ b/arch/x86/ia32/sys_ia32.c
> @@ -687,7 +687,7 @@ long sys32_vm86_warning(void)
>  		compat_printk(KERN_INFO
>  			      "%s: vm86 mode not supported on 64 bit kernel\n",
>  			      me->comm);
> -		strncpy(lastcomm, me->comm, sizeof(lastcomm));
> +		strncpy(lastcomm, me->comm, sizeof(lastcomm) - 1);
>  	}
>  	return -ENOSYS;
>  }

I don't see any problem with the code as written.  It is of course
correct that strncpy() doesn't null-terminate (it null-pads, which is
somewhat inefficient, but has info leak advantages), *however*, the only
user (it's a local static variable) uses strncpy(), so that's fine.

It probably could be done cleaner, but there is no actual bug, so I
personally don't see any reason to change it just in the interest of
avoiding churn.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


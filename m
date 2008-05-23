Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYEWHdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYEWHdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYEWHd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:33:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbYEWHdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:33:25 -0400
Date: Fri, 23 May 2008 00:32:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Khem Raj <raj.khem@gmail.com>
Cc: k.shutemov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux/a.out.h is not exported to userspace
Message-Id: <20080523003256.3ff82660.akpm@linux-foundation.org>
In-Reply-To: <1210983237.8550.28.camel@isis>
References: <1210983237.8550.28.camel@isis>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 17:13:57 -0700 Khem Raj <raj.khem@gmail.com> wrote:

> Hi,
> 
> Looking for a compile failure for a package on uclibc system using
> kernel-headers from 2.6.25 I found that linux/a.out.h is no more
> exported to userland anymore.
> 
> This commit below has disabled it from being exported. The commit Do not
> export asm/page.h during make headers_install so I was wondering if it
> was intended to unexport linux/a.out.h or not.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed7b1889da256977574663689b598d88950bbd23
> 
> 
> Looking at the patch from lkml post
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-10/msg08913.html
> 
> second hunk to include/linux/Kbuild was not applied which caused this
> problem.
> 
> I think I do not fall into Signed-off-by definition. I tested the
> following patch on 2.6.25.
> 
> Thanks
> 
> -Khem
> 
> Tested-by: Khem Raj <raj.khem@gmail.com>
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index b7d81b2..8a3d93e 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -168,6 +168,7 @@ unifdef-y += acct.h
>  unifdef-y += adb.h
>  unifdef-y += adfs_fs.h
>  unifdef-y += agpgart.h
> +unifdef-y += a.out.h
>  unifdef-y += apm_bios.h
>  unifdef-y += atalk.h
>  unifdef-y += atmdev.h

This breaks `make headerscheck' on s390:

/usr/src/devel/usr/include/linux/a.out.h requires asm/a.out.h, which does not exist in exported headers

which might be an s390 problem.

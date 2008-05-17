Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYEQOlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYEQOlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYEQOky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:40:54 -0400
Received: from the2masters.de ([213.146.113.64]:59751 "EHLO
	smtp.the2masters.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYEQOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:40:53 -0400
X-Greylist: delayed 4294 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 10:40:53 EDT
Message-ID: <482EDDA0.6050002@the2masters.de>
Date: Sat, 17 May 2008 15:29:04 +0200
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080218)
MIME-Version: 1.0
To: Khem Raj <raj.khem@gmail.com>
CC: k.shutemov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux/a.out.h is not exported to userspace
References: <1210983237.8550.28.camel@isis>
In-Reply-To: <1210983237.8550.28.camel@isis>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I saw this problem, too. The patch fixes this.

> I think I do not fall into Signed-off-by definition. I tested the
> following patch on 2.6.25.
> 
> Thanks
> 
> -Khem
> 
> Tested-by: Khem Raj <raj.khem@gmail.com>

Tested-by: Stefan Hellermann

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
> 

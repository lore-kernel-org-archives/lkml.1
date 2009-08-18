Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbZHRRvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbZHRRvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759371AbZHRRvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:51:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759344AbZHRRvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:51:23 -0400
Subject: Re: Make LSM_MMAP_MIN_ADDR default match its help text.
From: Eric Paris <eparis@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20090818174736.GA23352@redhat.com>
References: <200908172100.n7HL08SR001061@hera.kernel.org>
	 <20090818174736.GA23352@redhat.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 13:50:54 -0400
Message-Id: <1250617854.2239.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 13:47 -0400, Dave Jones wrote:
> Commit 788084aba2ab7348257597496befcbccabdc98a3 added the LSM_MMAP_MIN_ADDR
> option, whose help text states "For most ia64, ppc64 and x86 users with lots
> of address space a value of 65536 is reasonable and should cause no problems."
> Which implies that it's default setting was typoed.

Acked-by: Eric Paris <eparis@redhat.com>

This can wait or go now.  the tests against this are always a strict >
(not >=) and they are always rounded to PAGE_SIZE.  Thus both have the
same address protections.

-Eric

> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> --- linux-2.6.30.noarch/security/Kconfig~	2009-08-18 13:45:33.000000000 -0400
> +++ linux-2.6.30.noarch/security/Kconfig	2009-08-18 13:45:36.000000000 -0400
> @@ -116,7 +116,7 @@ config SECURITY_ROOTPLUG
>  config LSM_MMAP_MIN_ADDR
>  	int "Low address space for LSM to from user allocation"
>  	depends on SECURITY && SECURITY_SELINUX
> -	default 65535
> +	default 65536
>  	help
>  	  This is the portion of low virtual memory which should be protected
>  	  from userspace allocation.  Keeping a user from writing to low pages



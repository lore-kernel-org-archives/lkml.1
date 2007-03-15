Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbXCOCAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbXCOCAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 22:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXCOCAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 22:00:37 -0400
Received: from koto.vergenet.net ([210.128.90.7]:41997 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbXCOCAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 22:00:36 -0400
Date: Thu, 15 Mar 2007 10:46:38 +0900
From: Horms <horms@verge.net.au>
To: Ian Campbell <Ian.Campbell@XenSource.com>
Cc: vgoyal@in.ibm.com, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070315014635.GC28396@verge.net.au>
References: <1173891609.8591.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173891609.8591.41.camel@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 05:00:09PM +0000, Ian Campbell wrote:
> The specific case I am encountering is kdump under Xen with a 64 bit
> hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit due
> to the hypervisor but the dump kernel is 32 bit to match the domain 0
> kernel.
> 
> It's possibly less likely to be useful in a purely native scenario but I
> see no reason to disallow it.

For native Linux, would this cover the case where the pre-crash kernel
is 64bit and the crashdump (post-crash) kernel is 32bit?

> Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> 
> --- pristine-linux-2.6.18/include/asm-i386/elf.h	2006-09-20 04:42:06.000000000 +0100
> +++ linux-2.6.18-xen/include/asm-i386/elf.h	2007-03-14 16:42:30.000000000 +0000
> @@ -36,7 +36,7 @@
>   * This is used to ensure we don't load something for the wrong architecture.
>   */
>  #define elf_check_arch(x) \
> -	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
> +	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486) || ((x)->e_machine == EM_X86_64))

I think it would be a bit nicer if this was < 80col wide,
though obviously this doesn't affect the funtionality.

diff --git a/include/asm-i386/elf.h b/include/asm-i386/elf.h
index 8d33c9b..cd894dd 100644
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -36,7 +36,8 @@ typedef struct user_fxsr_struct elf_fpxregset_t;
  * This is used to ensure we don't load something for the wrong architecture.
  */
 #define elf_check_arch(x) \
-	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
+	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486) || \
+	 ((x)->e_machine == EM_X86_64))
 
 /*
  * These are used to set parameters in the core dumps.

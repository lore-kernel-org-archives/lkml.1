Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZCFIsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZCFIsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZCFIsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:48:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:21223 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZCFIsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:48:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Zvf0MB+MeWzkBCc5YQdkkEP8qVAqczNICAUB2B5lDUSpeztNkNcXlhG/pUGxHgGqNC
         pztoQf3YeYm2tSGANvx2eSlEBBzcDOlxFx0uB/ro9jzM3UtBGT+Jh7lEzjP7LXC2rzNM
         jdnAdG8S78AoCQNbM+T5sNzF3vc+Vl2WoOp/o=
Date: Fri, 6 Mar 2009 16:48:48 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ARCH=um segfault on x86-64.
Message-ID: <20090306084848.GO22605@hack.private>
References: <200903060042.19084.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200903060042.19084.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:42:14AM -0600, Rob Landley wrote:
>Apparently, nobody other than me has ever attempted to use User Mode Linux 
>built from 2.6.28 on x86-64, because it doesn't work.  It still doesn't work 
>in current git.  I complained about it not working back in January:
>
>http://sourceforge.net/mailarchive/forum.php?thread_name=200901130159.04389.rob%40landley.net&forum_name=user-
>mode-linux-devel
>http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00669.html
>
>And today, I bothered to track down why.
>
>This is the commit that broke it, when Peter Anvin merged x86 and x86-64 for 
>ARCH=um: http://kernel.org/hg/linux-2.6/rev/117978
>
>Here's a patch that fixes it for me:

Thanks, Bob!

>
>Signed-off-by: Rob Landley <rob@landley.net>
>
>diff -r 178a096e9e38 arch/um/Kconfig.x86
>--- a/arch/um/Kconfig.x86	Fri Feb 27 16:49:46 2009 -0800
>+++ b/arch/um/Kconfig.x86	Thu Mar 05 23:35:55 2009 -0600
>@@ -26,9 +26,8 @@
> 	def_bool !X86_XADD
> 
> config 3_LEVEL_PGTABLES
>-	bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT
>+	bool
> 	default 64BIT
>-	depends on EXPERIMENTAL


So, on i386, it will not depend on EXPERIMENTAL any more, right?

How about changing it to the following?

    depends on 64BIT || EXPERIMENTAL

> 	help
> 	Three-level pagetables will let UML have more than 4G of physical
> 	memory.  All the memory that can't be mapped directly will be treated
>>What changed is that the resulting .config no longer contains the line 
>"CONFIG_3_LEVEL_PGTABLES=y" (it's not visible, and thus not written out into 
>the config file file).  Without that symbol defined, x86-64 dies trying to 
>boot.  If you tweak the Kconfig so the symbol gets written out, it starts 
>working again.
>
>I have no idea how ANYBODY has EVER managed to use 2.6.28 User Mode Linux on 
>an x86-64 host.  My theory is that nobody ever did.  I suspect that very few 
>people use UML anymore now that KVM and the rustyvisor and such are available, 
>and those legacy users still fiddling with it are apparently all either using 
>old versions or 32-bit hosts.  (I still like being able to stick printfs into 
>the kernel.)
>

I am sorry that I never have an x86_64 machine to use. :(

-- 
Do what you love, f**k the rest! F**k the regulations!
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbXFUOf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbXFUOf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXFUOfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:35:20 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57160 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbXFUOfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:35:19 -0400
Message-ID: <467A8C9E.4030703@s5r6.in-berlin.de>
Date: Thu, 21 Jun 2007 16:35:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
References: <467543FA.60905@googlemail.com>	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>	 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>	 <1182381667.2701.7.camel@laptopd505.fenrus.org>	 <alpine.LFD.0.98.0706201649060.3593@woody.linux-foundation.org> <1182403401.2863.10.camel@laptopd505.fenrus.org>
In-Reply-To: <1182403401.2863.10.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> --- linux-2.6.22-rc5/arch/i386/Kconfig.debug.org	2007-06-20 22:20:30.000000000 -0700
> +++ linux-2.6.22-rc5/arch/i386/Kconfig.debug	2007-06-20 22:20:55.000000000 -0700
> @@ -49,7 +49,6 @@ config DEBUG_PAGEALLOC
>  config DEBUG_RODATA
>  	bool "Write protect kernel read-only data structures"
>  	depends on DEBUG_KERNEL
> -	depends on !KPROBES # temporary for 2.6.22
>  	help
>  	  Mark the kernel read-only data as write-protected in the pagetables,
>  	  in order to catch accidental (and incorrect) writes to such const
> --- linux-2.6.22-rc5/arch/x86_64/Kconfig.debug.org	2007-06-20 22:20:28.000000000 -0700
> +++ linux-2.6.22-rc5/arch/x86_64/Kconfig.debug	2007-06-20 22:20:44.000000000 -0700
> @@ -9,7 +9,6 @@ source "lib/Kconfig.debug"
>  config DEBUG_RODATA
>         bool "Write protect kernel read-only data structures"
>         depends on DEBUG_KERNEL
> -       depends on !KPROBES # temporary for 2.6.22
>         help
>  	 Mark the kernel read-only data as write-protected in the pagetables,
>  	 in order to catch accidental (and incorrect) writes to such const data.

Shouldn't we add something to the help texts?

+	This option also marks kernel text pages as write-protected,
+	except if you enable KPROBES.

CMIIW.

As mentioned elsewhere in this thread, replacing CONFIG_DEBUG_RODATA by
CONFIG_WRITEPROTECT_RODATA and CONFIG_WRITEPROTECT_TEXT might be a
better idea.  The latter should be mutual exclusive with CONFIG_KPROBES.
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/

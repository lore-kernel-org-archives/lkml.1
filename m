Return-Path: <linux-kernel-owner+w=401wt.eu-S968117AbXEHOHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968117AbXEHOHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968026AbXEHOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:07:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967803AbXEHOHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:07:37 -0400
Message-ID: <46408424.6050301@redhat.com>
Date: Tue, 08 May 2007 10:07:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Re: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
References: <20070508134928.GA13212@flint.arm.linux.org.uk>
In-Reply-To: <20070508134928.GA13212@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Russell King wrote:
> The change:
>
> +#ifdef CONFIG_HOTPLUG_CPU
> +#define __INIT		.section	".text","ax"
> +#define __INITDATA	.section	".data","aw"
> +#else
>  #define __INIT		.section	".init.text","ax"
> -#define __FINIT		.previous
>  #define __INITDATA	.section	".init.data","aw"
> +#endif
> +#define __FINIT		.previous
>
>   

Something is not right here.... was this the patch that I submitted?  If 
so then I definitely screwed up pretty badly.

I thought I had done (sorry for the cut-and-paste):

 
+#ifdef CONFIG_HOTPLUG_CPU
+#define __CPUINIT	.section	".text","ax"
+#define __CPUINITDATA	.section	".data","aw"
+#else
+#define __CPUINIT	__INIT
+#define __CPUINITDATA	__INITDATA
+#endif


Maybe some wires got crossed along the submit route...  Russell, I'll 
submit a fix against the latest tree.

P.

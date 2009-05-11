Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZEKSw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZEKSw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZEKSwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:52:17 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48749 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZEKSwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:52:16 -0400
Date: Mon, 11 May 2009 20:54:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
Message-ID: <20090511185424.GA32234@uranus.ravnborg.org>
References: <20090508154407.956216094@linux.vnet.ibm.com> <20090508154408.925135176@linux.vnet.ibm.com> <20090509050335.GC18129@hack> <4A07E536.9070609@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A07E536.9070609@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 10:43:34AM +0200, Peter Oberparleiter wrote:
> Américo Wang wrote:
> >On Fri, May 08, 2009 at 05:44:09PM +0200, Peter Oberparleiter wrote:
> >>From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> >>Index: linux-2.6.30-rc4/init/main.c
> >>===================================================================
> >>--- linux-2.6.30-rc4.orig/init/main.c
> >>+++ linux-2.6.30-rc4/init/main.c
> >>@@ -700,6 +700,18 @@ asmlinkage void __init start_kernel(void
> >>	rest_init();
> >>}
> >>
> >>+/* Call all constructor functions linked into the kernel. */
> >>+static void __init do_ctors(void)
> >>+{
> >>+#ifdef CONFIG_CONSTRUCTORS
> >>+	extern ctor_fn_t __ctors_start[], __ctors_end[];
> >
> >
> >I would like these to be globally decleared, since they are.
> 
> Ok, I will move the __ctors_* declarations to include/linux/ínit.h

include/asm-generic/sections.h please.
And please add a comment too.

That the other entries in the same file lacks a comment is not
the example to follow.

	Sam

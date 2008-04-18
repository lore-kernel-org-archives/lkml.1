Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYDRVw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYDRVw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYDRVwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:52:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYDRVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:52:17 -0400
Date: Fri, 18 Apr 2008 14:52:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: memtest bootparam
Message-Id: <20080418145202.c96460a2.akpm@linux-foundation.org>
In-Reply-To: <200804181717.m3IHHicT031344@hera.kernel.org>
References: <200804181717.m3IHHicT031344@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 17:17:44 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c64df70793a9c344874eb4af19f85e0662d2d3ee
> Commit:     c64df70793a9c344874eb4af19f85e0662d2d3ee
> Parent:     9b967106da0357ef8b08847dce35584a04134f20
> Author:     Yinghai Lu <yhlu.kernel.send@gmail.com>
> AuthorDate: Fri Mar 21 18:56:19 2008 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 17:41:21 2008 +0200
> 
>     x86: memtest bootparam
>     
> ...
>
>  
> +	memtest=	[KNL,X86_64] Enable memtest
> +			Format: <integer>
> +			range: 0,4 : pattern number
> +			default : 0 <disable>

OK.  Did the new memtest feature get documented anywhere, btw?  I'm only
vaguely aware of its existence.

>  
> +config MEMTEST_BOOTPARAM
> +	bool "Memtest boot parameter"
> +	depends on X86_64
> +	default y
> +	help
> +	  This option adds a kernel parameter 'memtest', which allows memtest
> +	  to be disabled at boot.  If this option is selected, memtest
> +	  functionality can be disabled with memtest=0 on the kernel
> +	  command line.  The purpose of this option is to allow a single
> +	  kernel image to be distributed with memtest built in, but not
> +	  necessarily enabled.
> +
> +	  If you are unsure how to answer this question, answer Y.
> +
> +config MEMTEST_BOOTPARAM_VALUE
> +	int "Memtest boot parameter default value (0-4)"
> +	depends on MEMTEST_BOOTPARAM
> +	range 0 4
> +	default 0
> +	help
> +	  This option sets the default value for the kernel parameter
> +	  'memtest', which allows memtest to be disabled at boot.  If this
> +	  option is set to 0 (zero), the memtest kernel parameter will
> +	  default to 0, disabling memtest at bootup.  If this option is
> +	  set to 4, the memtest kernel parameter will default to 4,
> +	  enabling memtest at bootup, and use that as pattern number.
> +
> +	  If you are unsure how to answer this question, answer 0.

These seem pointless.  Why not just unconditionally implement memtest=? 
All the code for that should be __init anyway so we're hardly saving
anything here.



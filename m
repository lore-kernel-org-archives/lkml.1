Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYDNPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYDNPoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbYDNPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:44:12 -0400
Received: from [198.99.130.12] ([198.99.130.12]:48322 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYDNPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:44:10 -0400
Date: Mon, 14 Apr 2008 11:43:42 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Fix another build error
Message-ID: <20080414154342.GA9434@c2.user-mode-linux.org>
References: <20080412.233914.54446044.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080412.233914.54446044.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 11:39:14PM +0800, WANG Cong wrote:
> 
> This patch fixes the following build error.
> 
>   CC      arch/um/drivers/mconsole_kern.o
> /home/wangcong/projects/linux-2.6/arch/um/drivers/mconsole_kern.c:337: error: redefinition of ‘mconsole_register_dev’
> /home/wangcong/projects/linux-2.6/arch/um/include/mconsole_kern.h:47: error: previous definition of ‘mconsole_register_dev’ was here
> make[2]: *** [arch/um/drivers/mconsole_kern.o] Error 1
> make[1]: *** [arch/um/drivers/mconsole_kern.ko] Error 2
> make: *** [sub-make] Error 2

This one is fishy.  For one thing, it looks like you reproduce this
with !CONFIG_MCONSOLE, but I just successfully built a
!CONFIG_MCONSOLE UML.

Second, the arch/um/drivers/Makefile looks to me (and the build log
confirms) that mconsole_kern.c isn't compiled with !CONFIG_MCONSOLE.

Third, you should ask yourself if there might be a deeper problem that
needs fixing if you find yourself putting #ifdef CONFIG_FOO in files
which implement FOO.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

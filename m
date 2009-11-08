Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZKHNG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZKHNG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZKHNG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:06:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZKHNG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:06:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
Date: Sun, 8 Nov 2009 13:06:20 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-server; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911081306.20201.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18YwTBoiH4jVGvXiHl+kgJdwo2+ztxuaGEPyK0
 wuTC6p44I0EnpQ+sWQ0K3oKxRQl1VKdV9jqgvSzH0HYRfEDkvL
 liZRi70Qg/J7bfuUbMMFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 November 2009 12:16:43 Eric W. Biederman wrote:
> This patchset reimplements sys_sysctl as a compatibility wrapper
> around /proc/sys.  After which it removes all of the code to all over
> the kernel that is used today to implement the binary sysctls.
> 
> I am posting this patchset to give everyone a heads up what is in
> flight.
> 
> I intend to carry all of these patches in my sysctl tree.

Very nice patches again!

Looking at what you did, I had two ideas how to move on from there,
which may be part of your plans already:

1. Make it possible to build sysctl_binary.c as a loadable module
so you can get a smaller kernel without losing the option to use
binary sysctl altogether. This of course requires a small portion
to remain in the kernel, to provide the actual syscall entry point
and load the module on demand.

2. On top of that, put the same code into glibc so that you don't
even have to load the module when you're running a new glibc version.
Since the binary sysctl ABI is stable (as in stiff and dead), there
should be no need to synchronize any extensions to it betwen kernel
and libc.

	Arnd <><

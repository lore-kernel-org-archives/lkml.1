Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbXGBOVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbXGBOVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXGBOVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:21:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:15109 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbXGBOVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:21:34 -0400
Message-ID: <46890A52.6020201@ru.mvista.com>
Date: Mon, 02 Jul 2007 18:23:14 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <200706291432.10128.m.kozlowski@tuxland.pl> <4685010C.4000108@ru.mvista.com> <4689025C.8000001@windriver.com>
In-Reply-To: <4689025C.8000001@windriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jason Wessel wrote:

>>>     allmodconfig on powerpc (iMac g3) fails due to
>>> git-kgdb.patch. allmodconfig defaults should be changed?

>>>   CC      arch/powerpc/kernel/kgdb.o
>>> arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB 
>>> selected in .config. Unselect one of them.
>>> make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
>>> make: *** [arch/powerpc/kernel] Blad 2

>>     I'm not sure if this will work out but maybe it's worth to disable 
>> XMON if KGDB is selected, like this?
>> config XMON
>>     bool "Include xmon kernel debugger"
>>     depends on DEBUGGER && !KGDB

> It did not seem that you can make a radio button / multi-select kernel 
> config option unless the options are in the same Kconfig file.  Given 
> that xmon and kgdb are mutually exclusive at the moment.

> What Sergei mentioned is the fix that needs to be used for the time being.
> Attached is the patch I put in the for_mm branch in the linux-2.6-kgdb 
> git tree.

> Jason.

> ------------------------------------------------------------------------

> xmon_or_kgdb.patch

> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] Turn off xmon if kgdb is active on ppc and powerpc

> Xmon and kgdb are mutuall exclusive at the moment so xmon should be
> turned off in the kernel config options if kgdb selected.  The case with "make allmodconfig" was failing and this patch addresses the problem.

> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

> ---
>  arch/powerpc/Kconfig.debug |    2 +-
>  arch/ppc/Kconfig.debug     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

    This patch does not seem complete as the #error that was tiggering has not 
been deleleted from arch/powerpc/kernel/kgdb.c (and not it's useless)

WBR, Sergei

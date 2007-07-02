Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbXGBOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbXGBOqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXGBOqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:46:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:44496 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbXGBOqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:46:11 -0400
Message-ID: <46890F8D.3080807@windriver.com>
Date: Mon, 02 Jul 2007 09:45:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: kgdb-bugreport@lists.sourceforge.net,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <200706291432.10128.m.kozlowski@tuxland.pl> <4685010C.4000108@ru.mvista.com> <4689025C.8000001@windriver.com> <46890A52.6020201@ru.mvista.com>
In-Reply-To: <46890A52.6020201@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2007 14:45:34.0074 (UTC) FILETIME=[A53EC5A0:01C7BCB7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
>
> Jason Wessel wrote:
>
>>>>     allmodconfig on powerpc (iMac g3) fails due to
>>>> git-kgdb.patch. allmodconfig defaults should be changed?
>
>>>>   CC      arch/powerpc/kernel/kgdb.o
>>>> arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB 
>>>> selected in .config. Unselect one of them.
>>>> make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
>>>> make: *** [arch/powerpc/kernel] Blad 2
>
>    This patch does not seem complete as the #error that was tiggering 
> has not been deleleted from arch/powerpc/kernel/kgdb.c (and not it's 
> useless)
>

I suppose the argument could be made to remove the check in the compiled 
file, but it does serve as a way to protect kgdb for now if someone 
tries to hard compile in xmon and kgdb.  Completely unpredictable 
results will occur with the debugger unless some pieces are fixed.  I 
would rather make sure until that happens there is no way head down the 
rat hole.

That issue aside would it be useful to have xmon+kgdb?  After having 
looked at the hook points for xmon, if a command was added to xmon to 
provide an "detach" it would be easy enough to have kgdb and xmon in the 
same kernel.  Obviously only one or the other can be used at any given time.

Jason.

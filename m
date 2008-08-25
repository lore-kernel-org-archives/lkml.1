Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYHYUpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYHYUpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYHYUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:45:35 -0400
Received: from mga05.intel.com ([192.55.52.89]:65265 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308AbYHYUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,266,1217833200"; 
   d="scan'208";a="609568341"
Message-ID: <48B319E6.3080508@linux.intel.com>
Date: Mon, 25 Aug 2008 13:45:26 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 25 Aug 2008, Alan D. Brunelle wrote:
>> Mine has:
>>
>> Dump of assembler code for function sys_init_module:
>> 0xffffffff802688c4 <sys_init_module+4>:	sub    $0x1c0,%rsp
>>
>> so 448 bytes.
> 
> Yeah, your build seems to have consistently bigger stack usage, and that 
> may be due to some config option, but most likely it's a compiler version 
> issue.
> 

I wonder if we ought to have a light version of "make checkstack" always run,
but in such a way that we make a file with "limits" on the stack usage for key
functions (and we can grow this list over time when we learn about critical ones)..
and either warn very loudly or even fail the build if we're way over what could work.


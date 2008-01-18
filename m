Return-Path: <linux-kernel-owner+w=401wt.eu-S1765280AbYARSxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765280AbYARSxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbYARSxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:53:25 -0500
Received: from tavolara.isolaweb.it ([80.247.74.3]:35011 "EHLO
	tavolara.isolaweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYARSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:53:24 -0500
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Fri, 18 Jan 2008 19:27:15 +0100
To: Arjan van de Ven <arjan@linux.intel.com>
From: Roberto Fichera <kernel@tekno-soft.it>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4790E3A6.7060807@linux.intel.com>
References: <4790E3A6.7060807@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <20080118182714.2DA32498006@tavolara.isolaweb.it>
X-IsolaWeb-MailScanner-Watermark: 1201285638.53895@+qI2NvT8L1cIYEuMcKp2Kg
X-IsolaWeb-MailScanner-Information: Please contact the ISP for more information
X-IsolaWeb-MailScanner: Found to be clean
X-MailScanner-From: kernel@tekno-soft.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 18.36 18/01/2008, Arjan van de Ven wrote:
>The Intel Open Source Technology Center is pleased to announce the
>release of version 0.1 of LatencyTOP, a tool for developers to visualize
>system latencies.
>
>http://www.latencytop.org
>

[...snip...]

>
>The most basic annotation looks like this (in the patches more complex
>versions can be seen):
>
>  asmlinkage long sys_sync(void)
>  {
>+       struct latency_entry reason;
>+       set_latency_reason("sync system call", &reason);
>         do_sync(1);
>+       restore_latency_reason(&reason);
>+
>         return 0;
>  }
>

I really like this patch :-)! Just a little note, why don't make 
the parameter 'char *reason' as simple integer (reason_t)? 
Making it as integer will automatically drop the strncmp() 
and speeding up all the things. Could be also interesting to 
define _externally_ the mapping of the reason so the 
userspace tool could handle it easily.

Roberto Fichera. 


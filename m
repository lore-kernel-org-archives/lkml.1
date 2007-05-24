Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbXEXIvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbXEXIvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbXEXIvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:51:06 -0400
Received: from as2.cineca.com ([130.186.84.242]:35920 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbXEXIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:51:05 -0400
Message-ID: <465551DC.4060603@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net> <464ED258.2010903@users.sourceforge.net> <20070520203123.5cde3224.akpm@linux-foundation.org> <20070524075835.GC21138@elte.hu>
In-Reply-To: <20070524075835.GC21138@elte.hu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Thu, 24 May 2007 10:50:49 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> Well OK.  But vdso-print-fatal-signals.patch is designated 
>> not-for-mainline anyway.
> 
> btw., why? It's very, very useful to distro, early-boot-userspace and 
> glibc development. The only add-on change should be to not print SIGKILL 
> events. Otherwise it's very much a keeper. Hm?
> 

Actually it seems that SIGKILLs are not printed. In get_signal_to_deliver() we have:

[snip]
@@ -1843,6 +1879,8 @@ relock:
 		 * Anything else is fatal, maybe with a core dump.
 		 */
 		current->flags |= PF_SIGNALED;
+		if ((signr != SIGKILL) && print_fatal_signals)
+			print_fatal_signal(regs, signr);
 		if (sig_kernel_coredump(signr)) {
 			/*
 			 * If it was able to dump core, this kills all
[snip]

-Andrea

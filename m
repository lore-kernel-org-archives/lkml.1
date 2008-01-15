Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYAOX2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYAOX2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYAOX2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:28:37 -0500
Received: from gw.goop.org ([64.81.55.164]:54313 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYAOX2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:28:36 -0500
Message-ID: <478D4197.8060904@goop.org>
Date: Tue, 15 Jan 2008 15:28:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
References: <patchbomb.1200435425@localhost> <20080115223534.GA20484@elte.hu>
In-Reply-To: <20080115223534.GA20484@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> unfortunately they dont solve it:
>
>  [   92.042586] Freeing unused kernel memory: 328k freed
>  [   92.091838] khelper used greatest stack depth: 6244 bytes left
>  [   92.281738] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
>  [   92.288761] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
>  [   92.295763] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
>  [...]
>  [   97.312484] printk: 611046 messages suppressed.
>
> 32-bit, PAE and RAM above 4GB seems to be enough to trigger that bug.
>   

Bum.  We established that once you fix the accessors+sign extension bug, 
there's another bug somewhere later on in the series.  Any chance you 
could move "x86/pgtable: fix constant sign extension problem" to be just 
after "x86/pgtable: unify pagetable accessors" and bisect the following 
patches?

Thanks,
    J

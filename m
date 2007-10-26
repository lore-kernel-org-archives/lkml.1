Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbXJZMdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbXJZMdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXJZMdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:33:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60420 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbXJZMdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:33:16 -0400
Date: Fri, 26 Oct 2007 14:33:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Hugh Dickins <hugh@veritas.com>
cc: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [RFC] brk randomization: compute RLIMIT_DATA properly
 (was Re: x86: randomize brk() and RLIMIT_DATA)
In-Reply-To: <Pine.LNX.4.64.0710261329450.27706@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0710261432510.25696@fbirervta.pbzchgretzou.qr>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
 <20071025071324.2eac21d6@laptopd505.fenrus.org> <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
 <20071025171942.pjff7jbpempfcuri@m.safari.iki.fi>
 <Pine.LNX.4.64.0710261235270.18815@twin.jikos.cz>
 <Pine.LNX.4.64.0710261247520.24322@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0710261414030.18815@twin.jikos.cz>
 <Pine.LNX.4.64.0710261329450.27706@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26 2007 13:30, Hugh Dickins wrote:
>> @@ -251,7 +251,8 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>>  	 * not page aligned -Ram Gupta
>>  	 */
>>  	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
>> -	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
>> +	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
>> +			(mm->end_data - mm->start_data) > rlim)
>>  		goto out;
>>  
>>  	newbrk = PAGE_ALIGN(brk);

Parentheses around (brk - mm->start_brk) + (mm->end_data - mm->start_data)
not strictly necessary.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbZJHPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbZJHPcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZJHPcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:32:31 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:34331 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZJHPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Nqfjy5cSz69Ao9ESPn4V/cMsab9EOh6wBhA+W/dRiue/WB6pB9Zc02bW6IQzwzmxH7
         kzr0trbxx8/Krt9sSscUX+nCqvTFVFaJo+42A1jz36Lc52gPO1zOMAuhnlVc/YBUR1wZ
         xaSHfy4npsKRuEYp50r6FU+1Hbl1NrjywoC8E=
Subject: Re: [PATCH] kernel/time/tick-sched.c: fix warning of printk's
 argument format
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain>
References: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com>
	 <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 08 Oct 2009 23:31:43 +0800
Message-Id: <1255015903.14496.44.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 08:03 -0700, Linus Torvalds wrote:
> 
> On Thu, 8 Oct 2009, Wu Zhangjin wrote:
> >
> > This patch will fix the following warning:
> 
> No it won't. It will add a lot of new warnings.
> 
> The thing is, almost all architectures (including x86) have
> 
> 	unsigned int __softirq_pending;
> 
> but then in <asm-generic/hardirq.h> we have
> 
> 	unsigned long __softirq_pending;
> 
> for some unfathomable reason. Quite frankly, I think Arnd just screwed up 
> the "generic" version, and the fix is almost certainly to just make the 
> generic version match all the main architectures. 
> 
> I don't have any architectures using the generic header file, though, so 
> I'm not going to do that change blindly. People who do should look at it 
> (alpha, powerpc and mips look like the only ones that might be 64-bit, but 
> I didn't check very carefully - just grepped for it)
> 
> Added Cc's for some people that have worked on, or used, that generic 
> header file. Is there any possible reason why it is "unsigned long" in 
> that one?
> 

I'm really using a MIPS machine! there is only a "unsigned long"
definition in include/asm-generic/hardirq.h.

Regards,
	Wu Zhangjin


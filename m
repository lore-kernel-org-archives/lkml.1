Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZJWVRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZJWVRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZJWVRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:17:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1035 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZJWVRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:17:07 -0400
Subject: Re: [RFC/PATCH] ratelimit: make output more useful
From: Joe Perches <joe@perches.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200910231712.00722.borntraeger@de.ibm.com>
References: <200910191706.42223.borntraeger@de.ibm.com>
	 <200910231458.11832.borntraeger@de.ibm.com>
	 <20091023145509.GA13793@elte.hu>
	 <200910231712.00722.borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Oct 2009 14:17:10 -0700
Message-ID: <1256332631.27122.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 17:12 +0200, Christian Borntraeger wrote:
> Am Freitag 23 Oktober 2009 16:55:09 schrieb Ingo Molnar:
> > Any reason why it couldnt be pushed inside printk.c? We just need the
> > func string - not the pointer pass-in. That would also address some of
> > the call-site bloat.

[]

> +extern int __printk_ratelimit(const char *func);
> +#define printk_ratelimit() __printk_ratelimit(__func__)

Perhaps check if CONFIG_KALLSYMS is defined and use

%pS ... __builtin_return_address(0) ?



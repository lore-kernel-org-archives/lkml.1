Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZL2HrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZL2HrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 02:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZL2HrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 02:47:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50786 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZL2HrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 02:47:15 -0500
Message-ID: <4B39B402.2040708@cs.helsinki.fi>
Date: Tue, 29 Dec 2009 09:47:14 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH] x86: Use KERN_DEFAULT log-level in __show_regs()
References: <1261988819.4641.2.camel@penberg-laptop>	 <1262029654.3352.27.camel@Joe-Laptop.home>	 <4B39AAF3.4060605@cs.helsinki.fi> <1262072421.1888.57.camel@Joe-Laptop.home>
In-Reply-To: <1262072421.1888.57.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

[ I'm restoring CC, dunno if I broke accidentally. ]

Joe Perches kirjoitti:
> On Tue, 2009-12-29 at 09:08 +0200, Pekka Enberg wrote:
>> Joe Perches kirjoitti:
>>> What is the reason to convert KERN_INFO to KERN_DEFAULT here?
>> To be consistent with rest of __show_regs() log-levels.
> 
> What log level is DEFAULT?
> 
> It's default 4 or WARNING, but I'd guess you had to
> look to find it.
> 
> Does anyone override it?
> 
> Why not simply specify KERN_WARNING for all of them?

For the reasons outlined here:

> from:
> $ git log -1 e28d713704117bca0820c732210df6075b09f13b
> This adds a KERN_DEFAULT loglevel marker, for when you cannot decide
> which loglevel you want, and just want to keep an existing printk
> with the default loglevel.

The whole point of the patch is to unify 32-bit and 64-bit wrt 
log-levels. The 32-bit version _is_ using KERN_DEFAULT implicitly and 
KERN_INFO is arguably wrong which is why I decided to go with the 
former. That way I don't need to go and audit all the callers of 
__show_regs() to see if KERN_WARN or some other level makes sense for them.

			Pekka

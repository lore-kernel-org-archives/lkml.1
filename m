Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYKKWHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYKKWHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYKKWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:07:10 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:40748 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYKKWHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:07:08 -0500
Message-ID: <491A01E2.2010701@cosmosbay.com>
Date: Tue, 11 Nov 2008 23:06:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
References: <s5htzaekp6o.wl%tiwai@suse.de>
In-Reply-To: <s5htzaekp6o.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 11 Nov 2008 23:06:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai a écrit :
> Hi,
> 
> we found that the kernel module sizes and memory footprints
> grow drastically when NR_CPUS is high.  For example, with
> NR_CPUS=4096, SUSE kernel packages weigh over 500MB (even w/o debug
> info).
> 
> A part of the reason is the fixed size array in struct module.
> The patch below fixes the problem by allocating it dynamically.
> With the patch, the size can go down to 20MB.
> 
> 
> Any comments/suggestions appreciated.
> 

Many attempts were done on this area on the past.

Your patch has the drawback of using kcalloc(), while previously, module_ref
space was allocated with vmalloc().

After a while, a machine could have a lot of vmalloc() space available, but not enough
physically contiguous space to fullfill a kmalloc(large_area) call.

So a module load could fail, while previous code could load module.

I believe Mike Travis has a better patch for this problem, partly using new percpu allocator.



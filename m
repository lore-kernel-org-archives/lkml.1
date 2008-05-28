Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYE1TEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYE1TEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYE1TEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:04:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41031 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYE1TEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:04:46 -0400
Date: Wed, 28 May 2008 12:02:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
 Barcelona
Message-ID: <20080528120253.26fcdb9d@infradead.org>
In-Reply-To: <20080528165813.8D8E5814C@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com>
	<20080528165813.8D8E5814C@erda.amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 10:17:39 +0200
Robert Richter <robert.richter@amd.com> wrote:

Hi,

As said before, I like the general approach. I have two comments below
though...

>  
> -	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
> +	if ((bus > 255) || (devfn > 255) || (reg > 4095))
>  		return -EINVAL;
>  

Comment 1:
Can we make the 256/4096 thing conditional on actually having the
feature somehow? (while not making the code TOO ugly)

Comment 2: 
The cpu_has_XXX is a bit dubious; while it's dependent on your cpu
model right now, I'm a bit hesitant to consider a PCI feature something
that belongs in the cpu_has_XXX namespace. (Yes I know PCI is moving
into the cpu package, but on a logical level it seems just the wrong
place).
Do we need a platform_has_XXX namespace for things like this?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

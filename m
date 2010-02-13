Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0BMDvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:51:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab0BMDvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:51:19 -0500
Message-ID: <4B762137.4050604@zytor.com>
Date: Fri, 12 Feb 2010 19:49:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical
 flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org> <m1zl3dre9e.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl3dre9e.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 07:44 PM, Eric W. Biederman wrote:
> 
> Thanks for keeping this work alive.
> 

Indeed.  I am hoping to put this in tip tomorrow or so.

> I just skimmed through do_IRQ and I happened to notice that
> we have an unnecessary inefficiency that using a radix tree for
> irq_to_desc will magnify.
> 
> handle_irq should take an struct irq_desc * instead of a unsigned int irq.
> 
> and the per cpu vector_irq array should become a per cpu vector_desc array.
> 
> As soon as irq_to_desc is more than &irq_desc[irq] this saves us work
> and cache line misses  at the cost of a simple code cleanup.

Good catch.  I haven't looked through the details yet, but I presume
this can be done on top of this changeset?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


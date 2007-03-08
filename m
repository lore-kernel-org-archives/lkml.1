Return-Path: <linux-kernel-owner+w=401wt.eu-S1030268AbXCHIli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268AbXCHIli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030298AbXCHIli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:41:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:20552 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268AbXCHIlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bn55UtVMVbY4LD5QxhBk3QBvLAKlogDfh02dKaNRtY2EgOhmVMqNXg3ZsoWZH4pc02yzHMqvEpiCbfxLDTBC7O5k2wOCsEB2fzydO/j3WXGmijuJlqa7fNU3+3hJPpIL3KB+twP1Qj7klNF1D+oRwFyvC3Ol1ewavhnx28CArCU=
Message-ID: <aec7e5c30703080041x6dd46309uef93ae0473bea91c@mail.gmail.com>
Date: Thu, 8 Mar 2007 17:41:30 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.21-rc2-mm2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070306192718.999e114d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	 <20070306192718.999e114d.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Following panic ouccurred (always) on ia64/NUMA(with empty node.)
>
> Bug in here.
> ==
> void move_native_irq(int irq)
> {
>         struct irq_desc *desc = irq_desc + irq;
>
>         if (likely(!(desc->status & IRQ_MOVE_PENDING)))
>                 return;
>
>         if (unlikely(desc->status & IRQ_DISABLED))
>                 return;
>
>         desc->chip->mask(irq);  <---------maybe this *mask* is NULL pointer
>         move_masked_irq(irq);
>         desc->chip->unmask(irq);
> }
> ==
>
> Is "mask"  always valid pointer ?

Not last time I checked. Have a look at "no_irq_chip" in
linux/kernel/irq/handle.c.

Your problem looks somewhat similar to the problem I had with irq
migration on ia64:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29a002776ba5ef170446910b1f93c480cdd43706

/ magnus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXGLFPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXGLFPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXGLFPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:15:14 -0400
Received: from ozlabs.org ([203.10.76.45]:47029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbXGLFPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:15:12 -0400
Subject: Re: [PATCH 1/2] SCHED: Generic hooks for trapping task preemption
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, shaohua.li@intel.com
In-Reply-To: <11841693333159-git-send-email-avi@qumranet.com>
References: <11841693332609-git-send-email-avi@qumranet.com>
	 <11841693333159-git-send-email-avi@qumranet.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 15:14:53 +1000
Message-Id: <1184217293.6005.754.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 18:55 +0300, Avi Kivity wrote:
> +	fire_sched_out_preempt_hooks(current);
>    	prepare_lock_switch(rq, next);
>  	prepare_arch_switch(next);

Damn, I just found a use for this in lguest.

Any chance of handing "next" to the sched_out hook so we can optimize
the lguest <-> lguest switch?

FYI, lguest turns off PGE globally when you load the module, because
turning it off on each guest entry v. slow.  With these hooks I can be
far smarter...

Thanks!
Rusty.



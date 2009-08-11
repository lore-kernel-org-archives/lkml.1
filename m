Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZHKLzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZHKLzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZHKLzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:55:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbZHKLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:55:15 -0400
Date: Mon, 10 Aug 2009 21:03:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, Nils Carlson <nils.carlson@ericsson.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] hpet: hpet driver periodic timer setup bug fixes
Message-Id: <20090810210312.eb3bb57f.akpm@linux-foundation.org>
In-Reply-To: <20090810220503.GA29239@linux-os.sc.intel.com>
References: <20090810220503.GA29239@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 15:05:04 -0700 "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> From: Nils Carlson <nils.carlson@ericsson.com>
> 
> The periodic interrupt from drivers/char/hpet.c does not work correctly,
> both when using the periodic capability of the hardware and while
> emulating the periodic interrupt (when hardware does not support
> periodic mode).
> 
> With timers capable of periodic interrupts, the comparator field is first
> set with the period value followed by set of hidden accumulator,
> which has the side effect of overwriting the comparator value. This
> results in wrong periodicity for the interrupts. For,
> periodic interrupts to work, following steps are necessary, in that order.
> * Set config with Tn_VAL_SET_CNF bit
> * Write to hidden accumulator, the value written is the time when the
>   first interrupt should be generated
> * Write compartor with period interval for subsequent interrupts
> (http://www.intel.com/hardwaredesign/hpetspec_1.pdf )
> 
> When emulating periodic timer with timers not capable of periodic
> interrupt, driver is adding the period to counter value instead of
> comparator value, which causes slow drift when using this emulation.
> 
> Also, driver seems to add hpetp->hp_delta both while setting up
> periodic interrupt and while emulating periodic interrupts with timers
> not capable of doing periodic interrupts. This hp_delta will result in
> slower than expected interrupt rate and should not be used while setting
> the interval.
> 

Do you have any thoughts on which kernel versions this fix should be
merged into, and when?

Thanks.

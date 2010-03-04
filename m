Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0CDI6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:58:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:57283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0CDI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:58:10 -0500
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com
In-Reply-To: <20100303220249.GF5194@nowhere>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.375353163@chello.nl>  <20100303220249.GF5194@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 09:58:07 +0100
Message-ID: <1267693087.25158.148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 23:02 +0100, Frederic Weisbecker wrote:
> On Wed, Mar 03, 2010 at 05:39:43PM +0100, Peter Zijlstra wrote:
> > Simply copy out the provided pt_regs in a u64 aligned fashion.
> > 
> > XXX: do task_pt_regs() and get_irq_regs() always clear everything or
> >      are we now leaking data?
> 
> 
> It looks like there is a leak in case of non trace syscalls.
> where we don't appear to save r12-15.
> 
> Then task_pt_regs() may leak the top of a process stack...?


Right, I was afraid of that. I've put this PERF_SAMPLE_REGS thing in the
freezer for now as people seem unsure how to deal with it.


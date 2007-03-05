Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbXCER3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbXCER3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbXCER3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:29:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:40858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbXCER3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:29:43 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: debug registers and fork
Date: Mon, 5 Mar 2007 18:25:16 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, tony.luck@intel.com
References: <20070226235154.GB19630@frankl.hpl.hp.com>
In-Reply-To: <20070226235154.GB19630@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051825.16473.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007 00:51, Stephane Eranian wrote:
> Hello,
> 
> I have come across an issue with a monitoring using the
> hardware debug registers on ia64/i386/x86-64.
> 
> It seems that the way debug registers are inherited across fork
> differs between ia-64 and i386/x86-64. On ia-64, the debug registers
> are NEVER inherited in the child. The copy_thread() routine clears
> the necessary thread flags to avoid reloading the debug registers in
> the child.
> 
> Now, on x86-64, it appears that the TIF_DEBUG flag is inherited via
> setup_thread_stack(). By virtue of dup_task_struct() the debug registers
> get copied into the child task on fork. So the child has active breakpoints,
> unless I am mistaken somewhere.
> 
> Given the way the ptrace() interface works, I would tend to
> think that the ia-64 way is the correct one. Any comment?

IA64 is probably correct, but changing this might break existing programs.
Would that be worth the change? What advantage would you have from it.

> Furthermore, on i386/x86-64, when switching out from a task with TIF_DEBUG
> enabled to another which does not, it seems we do not clear the debug
> registers (at least dr7) so they become inactive.

You mean they leak? Perhaps they should be cleared.

-Andi

 

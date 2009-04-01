Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbZDALk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbZDALk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZDALkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:40:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbZDALkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:40:08 -0400
Date: Wed, 1 Apr 2009 13:41:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v4 RFC PATCH 1/4] timers: Framework for identifying pinned timers
Message-ID: <20090401114146.GS11935@one.firstfloor.org>
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113258.GB22478@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401113258.GB22478@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 05:02:58PM +0530, Arun R Bharadwaj wrote:
> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-01 17:01:28]:
> 
> This patch creates a new framework for identifying cpu-pinned timers
> and hrtimers.
> 
> 
> This framework is needed because pinned timers are expected to fire on
> the same CPU on which they are queued. So it is essential to identify
> these and not migrate them, in case there are any.

How would that interact with add_timer_on()? You currently only
support the current CPU, don't you?

e.g. the new tip x86 machine check polling code relies on add_timer_on
staying on that CPU.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

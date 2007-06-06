Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXFFGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXFFGe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbXFFGev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:34:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39854 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712AbXFFGeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:34:50 -0400
Date: Wed, 6 Jun 2007 12:12:28 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070606064228.GA22443@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070531150908.GA23538@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531150908.GA23538@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 05:09:08PM +0200, Ingo Molnar wrote:
> i'm pleased to announce release -v15 of the CFS scheduler patchset.

Do I smell a bug when a task switches its scheduling classes?

Lets say a task was in real-time class for a long time and switches to
fair-sched class. When update_curr() is called on this new fair-sched
task, some of required fields (for ex: exec_start) are uninitialized and can 
lead to bogus calculations?

Also, real-time tasks are currently influencing fair clock calculations
(because there is only one raw_weighted_load field per runqueue). Is
that intentional?

-- 
Regards,
vatsa

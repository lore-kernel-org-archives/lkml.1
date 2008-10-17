Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYJQTjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYJQTjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYJQTjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:39:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196AbYJQTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:39:04 -0400
Message-ID: <48F8E958.5080907@linux-foundation.org>
Date: Fri, 17 Oct 2008 14:36:56 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> Even one line bouncing between cpus can be a performamce disaster.
> You'll probably hit a serious wall somewhere between 8 and 16
> cpus (ia64 has code that looks a lot like this in the gettimeofday()
> path because it does not synchronize cpu cycle counters ... some


The code exist by necessity because some systems do not have synchronized ITCs
and one would not have time go backward. The cmpxchg there is usually switched
off. Its horrible in terms of scaling to large numbers of processor and also
horrible in terms of clock accuracy.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZKHMzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZKHMzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZKHMzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:55:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZKHMzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:55:38 -0500
Date: Sun, 8 Nov 2009 13:55:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
Message-ID: <20091108125527.GA19350@elte.hu>
References: <1257233486.22553.6.camel@wall-e>
 <20091103082843.GA27676@elte.hu>
 <1257239184.4889.15.camel@wall-e>
 <1257409189.26874.18.camel@wall-e>
 <20091108113546.GN11372@elte.hu>
 <1257684666.20579.9.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257684666.20579.9.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefani Seibold <stefani@seibold.net> wrote:

> > I'd suggest a competely different method: why dont you use an IPI to 
> > sample the SP whenever someone wants to read it from /proc and we 
> > see that the task is running on a CPU right now?
> 
> Sounds like a challenge, i like the idea. I will have a look on it...

It's not a fastpath, so smp_function_call() ought to do the trick.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYJWLQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYJWLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYJWLQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:16:17 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:20107 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYJWLQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:16:17 -0400
Message-ID: <49005CD0.2070807@siemens.com>
Date: Thu, 23 Oct 2008 13:15:28 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/13 v2] ftrace: do not trace init sections
References: <20081022212721.167005680@goodmis.org> <20081022213552.440512191@goodmis.org>
In-Reply-To: <20081022213552.440512191@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The recordmcount script is now robust enough not to process any sections
> but the .text section. But the gcc compiler still adds a call to mcount.
> 
> Note: The function mcount looks like:
> 
>   ENTRY(mcount)
> 	ret
>   END(mcount)
> 
> Which means the overhead is just a return.
> 
> This patch adds notrace to the init sections to not even bother calling
> mcount (which simply returns).

Sorry for a potentially dumb question (didn't follow all recent ftrace
developments), but doesn't this mean that code in such sections is now
invisible for all tracers, even with dynamic tracing disabled (in which
case they should cause no problem)? What if you *do* want to have such
functions in your trace as they may contribute to problem or give other
useful hints?

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux

Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbZJFXZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbZJFXZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbZJFXZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320AbZJFXZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:25:43 -0400
Message-ID: <4ACBD1BF.30201@redhat.com>
Date: Tue, 06 Oct 2009 16:24:47 -0700
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, mhiramat@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
References: <cover.1253831945.git.jbaron@redhat.com> <20091006053915.D9D0928@magilla.sf.frob.com>
In-Reply-To: <20091006053915.D9D0928@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2009 10:39 PM, Roland McGrath wrote:
> Of course, a first important point is what the actual compiled code
> sequences look like.  I'm hoping Richard (who implemented the compiler
> feature for us) can help us with making sure our expectations jibe with the
> code we'll really get.  There's no benefit in optimizing our asm not to
> introduce a jump into the hot path if the compiler actually generates the
> tracing path first and gives the hot path a "jmp" around it anyway.

At present, the asm goto extension gives no prediction weights to any 
path.  I had hoped that the -freorder-blocks pass (enabled with -O2) 
would automatically place the relevant fallthrough blocks immediately 
after the asm goto.  It did happen for small test cases, but a message 
from Jason downthread indicates that it doesn't always happen.

> 	if (__builtin_expect(0,0)) do_trace: __attribute__((cold)) { ... }

An attribute cold on a label is something that I've suggested, but have 
not yet implemented.  I think that might be the easiest way to add 
prediction weights to an asm goto.


r~

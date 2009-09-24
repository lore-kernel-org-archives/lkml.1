Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZIXQx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZIXQx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZIXQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:53:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZIXQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:53:26 -0400
Message-ID: <4ABBA3DD.2040403@zytor.com>
Date: Thu, 24 Sep 2009 09:52:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
References: <20090924123154.GA12907@Krystal> <20090924123428.GA27282@elte.hu> <20090924140228.GA2648@redhat.com> <4ABB7F58.5030508@zytor.com> <20090924153900.GB2648@redhat.com>
In-Reply-To: <20090924153900.GB2648@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> 
> that's right. The optimal solution doesn't require the the NOP5 at all,
> and I've been playing around with an implementation that doesn't have
> it. The problem I've been running into is that sometimes the compiler
> will put in a short jump - '0xeb', with a 1 byte offset, but the jump
> target is further away. Thus, I need to either ensure the target is
> close, or somehow force a longer jump '0xe9' into the code so I always
> have the space. The other advantage of not including the nop is easier
> support for all x86 implementations, since I'm not sure a 5 byte atomic
> nop is always available, whereas a jump is always atomic. I'm pretty
> sure we can come up with a patch that avoids the nop...I'll keep working
> on it.
> 

Unfortunately gas doesn't have any equivalent of the NASM "strict" 
operand modifier, which would be ideal here.  The following *seems* to 
work on binutils-2.18.50.0.9-8.fc10.x86_64 at least:

	.byte 0xe9
	.long %0-1f
1:

	-hpa


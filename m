Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXKPLxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXKPLxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXKPLxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:53:05 -0500
Received: from dpc691978010.direcpc.com ([69.19.78.10]:35191 "EHLO
	third-harmonic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbXKPLxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:53:04 -0500
Message-ID: <473D8560.5060500@third-harmonic.com>
Date: Fri, 16 Nov 2007 06:56:16 -0500
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Tim Bird <tim.bird@am.sony.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: MIPS RT debug support
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain> <473BADD4.5030400@third-harmonic.com> <473CD6E1.1060607@am.sony.com> <Pine.LNX.4.58.0711151956430.30058@gandalf.stny.rr.com> <473CF8A5.9030101@third-harmonic.com> <Pine.LNX.4.58.0711152121340.30058@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0711152121340.30058@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> IIRC, only CALLER_ADDR0 is actually used (I've found that the others are
> mostly unreliable).

I seem to recall more use was made of __builtin_return_address(n)
for 0 < n in the past compared to the current code.  Likely for
shallow frames the 0 < n calls were potentially returning invalid
data which is why they currently appear to be commented out.

Rather than lobbying to fix __builtin_return_address(), replacing
it with a primitive which works in all cases seems an easier
solution.  That stub stack frame really does provide useful debug
information.  In the case of ARM I simply walked the stack.  Worst
case in that vintage of the code was four iterations so the overhead
was in the noise.  That same solution could easily be applied to
other architectures.

> It's been several years since
> I've worked on mips (I'd love to do it again, if someone sends me a box!,
> hint hint).

Concerning a MIPS board, if no freebies should arrive you
might want to dig up a linux footprint friendly version of
a Linksys WRT54GS.

-john

-- 
john.cooper@third-harmonic.com

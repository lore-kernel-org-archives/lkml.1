Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXLEFxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXLEFxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 00:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXLEFxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 00:53:32 -0500
Received: from sineb-mail-2.sun.com ([192.18.19.7]:39342 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXLEFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 00:53:32 -0500
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2007 00:53:31 EST
Date: Wed, 05 Dec 2007 15:33:33 +1000
From: David Holmes - Sun Microsystems <David.Holmes@sun.com>
Subject: Re: [PATCH -v2] fix for futex_wait signal stack corruption
In-reply-to: <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <4756382D.4040904@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1196801858.1645.37.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
 <20071204213924.GA14915@goodmis.org>
 <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds said the following on  5/12/07 01:41 PM:
> So here's a question for David Holmes:  What caused you to actually notice 
> this behaviour? Can this actually be seen in real life usage?

We observed an application "hang" that turned out to be caused by a 
clock mismatch between that used with the pthread_cond_t and that used 
to convert a relative wait time to an absolute one. When the program ran 
in the foreground and hung I used ctrl-Z to suspend it then "bg" to 
background it. As soon as I did that the application became unstuck.

While this was observed with process control signals, my concern was 
that other signals might cause pthread_cond_timedwait to return 
immediately in the same way. The test program allows for SIGUSR1 and 
SIGRTMIN testing as well, but these other signals did not cause the 
immediate return. But it would seem from Steven's analysis that this is 
just a fortuitous result. If I understand things correctly, any 
interruption of pthread_cond_timedwait by a signal, could result in 
waiting until an arbitrary time - depending on how the stack value was 
corrupted. Is that correct?

Thanks,
David Holmes
Senior Java Technologist
Java SE VM Real-time and Embedded Group
---------------------------------------

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbXFDRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbXFDRhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXFDRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:37:29 -0400
Received: from waste.org ([66.93.16.53]:53171 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXFDRh2 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:37:28 -0400
Date: Mon, 4 Jun 2007 12:37:10 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org
Cc: Linux-kernel@vger.kernel.org
Subject: Interesting interaction between lguest and CFS
Message-ID: <20070604173710.GR11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.22-rc3-mm1, I've got a long-running video transcoding going
on. In other windows, I'm compiling, reading email, etc. with no
noticeable problems.

If I fire up lguest and leave it sitting at a shell prompt for a
couple moments, when I return to type something at the prompt, it can
take 2-3 seconds for my input to echo. Once it starts responding,
typing latency disappears. Suspend the other app and the latency
disappears.

The system isn't swapping and has basically no I/O load.

Ok, my transcoding just finished as I was writing this. So I've
reproduced the problem with this Python script that I had handy:

memload.py:
#!/usr/bin/python
a = "a" * 16 * 1024 * 1024
while 1:
    b = a[1:] + "b"
    a = b[1:] + "c"

-- 
Mathematics is the supreme nostalgia of our time.

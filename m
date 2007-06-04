Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbXFDWw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbXFDWw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbXFDWwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:52:18 -0400
Received: from lixom.net ([66.141.50.11]:43373 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbXFDWwR (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:52:17 -0400
Date: Mon, 4 Jun 2007 17:58:27 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org, Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604225827.GA4280@lixom.net>
References: <20070604173710.GR11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604173710.GR11166@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 12:37:10PM -0500, Matt Mackall wrote:
> With 2.6.22-rc3-mm1, I've got a long-running video transcoding going
> on. In other windows, I'm compiling, reading email, etc. with no
> noticeable problems.
> 
> If I fire up lguest and leave it sitting at a shell prompt for a
> couple moments, when I return to type something at the prompt, it can
> take 2-3 seconds for my input to echo. Once it starts responding,
> typing latency disappears. Suspend the other app and the latency
> disappears.
> 
> The system isn't swapping and has basically no I/O load.

Is this on hvc console? The hvc driver was recently modified to back off
it's timing interval when there's no input, the max value is 2 seconds.

See b791072ba3c3b29bab1890963bde52eb944a8451 for the changes in question.


-Olof


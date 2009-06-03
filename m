Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZFCTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZFCTOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZFCTOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:14:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZFCTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:14:10 -0400
Date: Wed, 3 Jun 2009 15:14:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] ring-buffer: try to discard unneeded timestamps
In-Reply-To: <4A26C6EC.30609@am.sony.com>
Message-ID: <alpine.DEB.2.00.0906031510470.14994@gandalf.stny.rr.com>
References: <20090603141605.001049251@goodmis.org> <20090603141651.231310727@goodmis.org> <4A26C6EC.30609@am.sony.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Jun 2009, Tim Bird wrote:
> 
> Is this new routine only for discarding uncommitted events,
> or can it be used on committed events?
> 
> I assume the former, since I see nothing about adjusting the
> commit position.

Only uncommitted events.

> 
> In the ring_buffer API I see that there's a function for
> discarding events (committed ones), but not for free-ing them.
> In function duration filtering, it is desirable to free the
> last committed event, which for a function exit of short
> duration will be it's entry event 99% of the time.

In filtering we deside before commiting if we want to discard or not. 
(Note, this is only in tip right now.)  Once we commit it, there is no way 
to safely remove it from the ring buffer. Additions of items are not under 
a lock (only the moving from page to page is).

For the event tracer we check if we want to disard it or not before we 
commit.

> 
> P.S. I'm very sorry about the missing '>' on the Signed-off-by line.
> I ran checkpatch and got a passing score, but missed this.

No prob, you only made me spam LKML (and others) with about 10 gargage 
emails ;-)

-- Steve


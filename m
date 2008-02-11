Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYBKQcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYBKQcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbYBKQc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:32:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbYBKQc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:32:26 -0500
Date: Mon, 11 Feb 2008 17:31:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>
Subject: Re: [17/19] ftrace: dynamic enabling/disabling of function calls
Message-ID: <20080211163138.GA2272@elte.hu>
References: <20080210072109.GR4100@elte.hu> <47B06B4E.1010704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B06B4E.1010704@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> > Because we do this via stop_machine, we don't have to worry about 
> > another CPU executing a ftrace call as we modify it. But we do need 
> > to worry about NMI's so all functions that might be called via nmi 
> > must be annotated with notrace_nmi. When this code is configured in, 
> > the NMI code will not call notrace.
> 
> I'd like to suggest that you can use djprobe-like solution here to 
> eliminate stop_machine. The djprobe makes a bypass over that call 
> instruction by using a kprobe, and after replacing the call 
> instruction, you can safely remove the bypass. [...]

i think the stop_machine() method for code patching is pretty elegant in 
that it reuses an otherwise rarely used but critical facility. We want 
it to be fast and easy, and our current ftrace testing shows that it is. 
So unless there are strong reasons to do otherwise, it would be nice to 
keep that approach :-)

	Ingo

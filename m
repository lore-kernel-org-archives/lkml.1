Return-Path: <linux-kernel-owner+w=401wt.eu-S1762397AbYA2PN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397AbYA2PN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYA2PNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:13:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYA2PNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:13:48 -0500
Message-ID: <479F4291.1060106@redhat.com>
Date: Tue, 29 Jan 2008 10:13:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: ananth@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       jkenisto@us.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com> <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
In-Reply-To: <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:
> Placing a breakpoint on kprobe_handler (say) can loop into a recursive
> trap without allowing the debugger's notifier chain to be invoked. I'm
> assuming that non-kprobe exception notifiers may (or even should) run
> after kprobe's notifier callback (kprobe_exceptions_notify).

In that case, why don't you just reduce the priority of kprobe_exceptions_nb?
Then, the execution path becomes very simple.

int3 (non-kprobe) -> do_int3 -> non-krpobe/debugger

I also like to use a debugger for debugging kprobes. that will help us.

Best Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


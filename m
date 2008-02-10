Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYBJPTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYBJPTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYBJPTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:19:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56819 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYBJPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:19:33 -0500
Date: Sun, 10 Feb 2008 16:19:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [12/19] ftrace: function tracer
Message-ID: <20080210151911.GA28201@elte.hu>
References: <20080210072046.GM4100@elte.hu> <20080210095353.GA8451@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210095353.GA8451@kernel.sg>
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


* Eugene Teo <eugeneteo@kernel.sg> wrote:

> kerndev: /sys/kernel/debug/tracing$ cat current_tracer 
> ftrace
> kerndev: /sys/kernel/debug/tracing$ cat tracing_enabled 
> 1
> kerndev: /sys/kernel/debug/tracing$ cat iter_ctrl 
> noprint-parent nosym-offset nosym-addr noverbose 
> kerndev: /sys/kernel/debug/tracing$ echo symonly > iter_ctrl 
> kerndev: /sys/kernel/debug/tracing$ cat iter_ctrl 
> noprint-parent nosym-offset nosym-addr noverbose 
> 
> How did you get the above output?

the logic is this: the iter_ctl flags are either "noprint-parent" or 
"print-parent". You can toggle it by writing the opposite into that 
file. The "symonly" was an older flag - we'll update documentation with 
that.

so for example to print out the symbol addresses in hexa too, do:

    echo sym-addr > iter_ctrl

to turn that aspect of trace display off, do:

    echo nosym-addr > iter_ctrl

we'll gravitate the defaults to something that is OK to most people, but 
certain purposes need more (or less) information, so the various toggles 
are still quite useful. (Previously we kept all the toggles as separate 
switches, but that was more confusing - now it's concentrated into a 
single control.)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZLCOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZLCOz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZLCOzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:55:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbZLCOzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:55:20 -0500
Date: Thu, 3 Dec 2009 15:55:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Fix event format export
Message-ID: <20091203145504.GA959@elte.hu>
References: <20091113224009.GB23942@elte.hu>
 <tip-811cb50baf63461ce0bdb234927046131fc7fa8b@git.kernel.org>
 <1259851297.12870.134.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259851297.12870.134.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2009-11-14 at 10:18 +0000, tip-bot for Johannes Berg wrote:
> > Commit-ID:  811cb50baf63461ce0bdb234927046131fc7fa8b
> > Gitweb:     http://git.kernel.org/tip/811cb50baf63461ce0bdb234927046131fc7fa8b
> > Author:     Johannes Berg <johannes@sipsolutions.net>
> > AuthorDate: Fri, 13 Nov 2009 23:40:09 +0100
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Fri, 13 Nov 2009 22:20:34 -0500
> > 
> > tracing: Fix event format export
> > 
> > For some reason the export of the event print format to userspace
> > uses '#fmt' which breaks if the format string is anything but a plain
> > string, for example if it is built with macros then the macro names
> > are exported instead of their contents.
> > 
> > Use
> > 	"\"%s\"", fmt
> > instead of
> > 	"%s", #fmt
> > to export the string and not the way it is built.
> > 
> > For example, in net/mac80211/driver-trace.h for the trace event drv_start
> > there is:
> > 
> >         TP_printk(
> >                 LOCAL_PR_FMT, LOCAL_PR_ARG
> >         )
> > 
> > Which use to produce:
> > 
> >  print fmt: LOCAL_PR_FMT, REC->wiphy_name
> > 
> > Now produces:
> > 
> >  print fmt: "%s", REC->wiphy_name
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > LKML-Reference: <20091113224009.GB23942@elte.hu>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> 
> Ingo,
> 
> Any reason that this did not make it into Mainline? 2.6.32 is out, and 
> Johannes Berg was depending on this for his users.

Yeah, it narrowly missed the last -rc (-rc8), and we only push 
post-final-rc fixes for serious show-stopper regressions.

v2.6.32.1 will have this (and other) fixes. Johannes can cherry-pick the 
fix in a day or so once it hits Linus's tree in the merge window.

Thanks,

	Ingo

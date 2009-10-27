Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZJ0XdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZJ0XdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZJ0XdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:33:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbZJ0XdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:33:14 -0400
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
	 <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
	 <1256679318.26028.468.camel@gandalf.stny.rr.com>
	 <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 19:31:25 -0400
Message-Id: <1256686285.26028.487.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:23 -0800, Suresh Siddha wrote:

> > 
> > I'll test it out, and if it does work, you can write up a formal patch
> > and remove the !define that I added.
> 
> I just saw one more place calling do_ftrace_mod_code(). So moved this
> check inside the do_ftrace_mod_code(). Does this cover all the cases?
> Thanks.

For ftrace, probably. But I just realized this may have other
consequences. The CPA_DEBUG tests setting a bit in the page table at
random locations. The code you added makes any change to kernel text
page attributes remove the RW bit. On boot up, it is considered that
kernel text is writable.

Perhaps you need to add a check in your if statement to only prevent
that bit when kernel_set_to_readonly is not true.

-- Steve



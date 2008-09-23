Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYIWPFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYIWPFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYIWPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:05:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbYIWPFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:05:39 -0400
Date: Tue, 23 Sep 2008 11:02:09 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923150209.GF29900@redhat.com>
References: <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Sep 23, 2008 at 11:36:26PM +0900, KOSAKI Motohiro wrote:
> > By the way, systemtap uses two modes;
> > 
> > - single-channel mode
> >  In this mode, all cpus share one buffer channel to write and read.
> >  each writer locks spinlock and write a probe-local data to buffer.
> > - per-cpu buffer mode [...]
> 
> I can't imazine a merit of the single-channel mode.
> Could you please explain it?

It could be a way of saving some memory and merging hassle for
low-throughput data.  (Remember that systemtap enables in-situ
analysis of events so that often only brief final results need be sent
along need be sent out.)  If timestampwise cross-cpu merging can be
done on demand by the hypothetical future buffer widget, then little
reason remains not to use it.

- FChE

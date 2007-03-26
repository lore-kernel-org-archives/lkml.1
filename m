Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbXCZNJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbXCZNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 09:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXCZNJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 09:09:59 -0400
Received: from verein.lst.de ([213.95.11.210]:37994 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXCZNJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 09:09:58 -0400
Date: Mon, 26 Mar 2007 08:55:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move die notifier handling to common code
Message-ID: <20070326065524.GA1163@lst.de>
References: <20070319160218.GA27462@lst.de> <17927.8857.752570.69739@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17927.8857.752570.69739@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 1.363 (*) DATE_IN_PAST_06_12
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 11:32:09AM +1000, Paul Mackerras wrote:
> Seems OK, although I think kprobes should not be using notify_die.
> The set of events that kprobes is interested in has no intersection at
> all with the set that any other consumer of the notify_die events is
> interested in, on any architecture.
> 
> Furthermore, the multiplexing of the kprobes events through notify_die
> really serves no useful purpose.  It just means that
> kprobe_exceptions_notify has to demultiplex the events with a switch
> statement.  There is no significant common code for all events in
> kprobe_exceptions_notify, just a simple check whether the event
> happened in user mode.
> 
> However, all that is in arch code so can be changed per-arch if
> desired.

I tend to agree.  Unfortunately powers higher than me like these
horrible notifier schemes.  Then again at least the die path is not
performance critical unlike the page faul path where I still need a
comment for you on getting rid of the notifier.

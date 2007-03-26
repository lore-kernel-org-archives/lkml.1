Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXCZBcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXCZBcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbXCZBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:32:16 -0400
Received: from ozlabs.org ([203.10.76.45]:47020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbXCZBcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:32:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.8857.752570.69739@cargo.ozlabs.ibm.com>
Date: Mon, 26 Mar 2007 11:32:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move die notifier handling to common code
In-Reply-To: <20070319160218.GA27462@lst.de>
References: <20070319160218.GA27462@lst.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:

> This patch moves the die notifier handling to common code.  Previous
> various architectures had exactly the same code for it.  Note that
> the new code is compiled unconditionally, this should be understood
> as an appel to the other architecture maintainer to implement
> support for it aswell (aka sprinkling a notify_die or two in the
> proper place)

Seems OK, although I think kprobes should not be using notify_die.
The set of events that kprobes is interested in has no intersection at
all with the set that any other consumer of the notify_die events is
interested in, on any architecture.

Furthermore, the multiplexing of the kprobes events through notify_die
really serves no useful purpose.  It just means that
kprobe_exceptions_notify has to demultiplex the events with a switch
statement.  There is no significant common code for all events in
kprobe_exceptions_notify, just a simple check whether the event
happened in user mode.

However, all that is in arch code so can be changed per-arch if
desired.

Paul.

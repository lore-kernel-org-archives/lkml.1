Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbXJaOVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbXJaOVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 10:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXJaOVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 10:21:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56830 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbXJaOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 10:21:31 -0400
Date: Wed, 31 Oct 2007 07:19:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031071907.2d1b02ed@laptopd505.fenrus.org>
In-Reply-To: <1193788979.5623.43.camel@localhost.localdomain>
References: <1193788979.5623.43.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 20:02:59 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Is there any reason why we don't do a dump_stack on panic?


panic() should never be used for kernel type of bugs, that's what
BUG_ON() is for. panic() tends to be for "your cpu melted" and "you
don't have a root fs".. nothing else.

for both of those cases, a stack trace actually hurts because it
scrolls the useful information off the screen instead.

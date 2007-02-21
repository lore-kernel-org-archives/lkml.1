Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbXBUKPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbXBUKPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXBUKPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:15:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbXBUKPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:15:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1: PTRACE=y, PROC_FS=n compile error
In-Reply-To: Adrian Bunk's message of  Tuesday, 20 February 2007 01:08:16 +0100 <20070220000816.GM13958@stusta.de>
X-Windows: warn your friends about it.
Message-Id: <20070221101510.C48121800E4@magilla.sf.frob.com>
Date: Wed, 21 Feb 2007 02:15:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This causes the following compile error with CONFIG_PTRACE=y, 
> CONFIG_PROC_FS=n:

Bah.  I moved ptrace_may_attach to fs/proc/base.c so that CONFIG_PTRACE=n
could just omit kernel/ptrace.c entirely and still get the function for
fs/proc/base.c to use (and because that uses it many more times than ptrace
does).  I'd forgotten that procfs could be disabled, since noone ever does.

What do people suggest?  It's not a very big function.


Thanks,
Roland

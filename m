Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbZBEA5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbZBEA5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbZBEA4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:56:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZBEA4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:56:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ptrace: kill __ptrace_detach(), fix ->exit_state check
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 05:29:14 +0100 <20090129042913.GA5100@redhat.com>
References: <20090129042913.GA5100@redhat.com>
X-Shopping-List: (1) Lunar concussion gongs
   (2) Strategic promotion bread
   (3) Groundless card samples
Message-Id: <20090205005639.90FB5FC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 16:56:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Move the code from __ptrace_detach() to its single caller and kill this
> helper.
> 
> Also, fix the ->exit_state check, we shouldn't wake up EXIT_DEAD tasks.

Yes, though that is probably impossible anyway.  Perhaps in a de_thread
race, but probably harmlessly does nothing.  Anyway, certainly fine to
change the test to match all others of the same ilk.

> Actually, I think task_is_stopped_or_traced() makes more sense, but this
> needs another patch.

Agreed.  It is one of those nasty cases where the old semantics are
"clearly" wrong, but it's very hard not to worry that some obscure
combination of circumstances means that some common-enough case actually
depends on the "wrong" wakeup.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZBEVdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZBEVdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBEVcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:32:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZBEVct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:32:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee
	of ptrace_exit()
In-Reply-To: Oleg Nesterov's message of  Thursday, 5 February 2009 15:39:59 +0100 <20090205143959.GA20953@redhat.com>
References: <20090129042920.GA5111@redhat.com>
	<20090205012334.9E60FFC381@magilla.sf.frob.com>
	<20090205143959.GA20953@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090205203731.1E02BFC381@magilla.sf.frob.com>
Date: Thu,  5 Feb 2009 12:37:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Given its content, this function now better belongs in ptrace.c, I think.
> 
> I don't completely agree... This helper imho has nothing to do with
> ptracing, except it does __ptrace_unlink(). But OK, I will move it
> if you prefer. 

Obviously where it goes is not a big deal.  But I think it's clear that it
has everything to do with ptrace and nothing to do with anything else.
It resolves a situation that can only arise because of ptrace magic.

> In that case we should export task_detached().

Or just recognize that this trivial wrapper around == -1 has little
value two lines away from a place where = -1 is done explicitly.  
Really, the "abstraction" is more confusing than not in this function, IMHO.


Thanks,
Roland

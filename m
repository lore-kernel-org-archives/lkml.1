Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbZBEBbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbZBEBbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZBEBbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:31:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZBEBbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:31:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ptrace: fix possible zombie leak on PTRACE_DETACH
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 05:29:23 +0100 <20090129042923.GA5118@redhat.com>
References: <20090129042923.GA5118@redhat.com>
X-Zippy-Says: ...A housewife is wearing a polypyrene jumpsuit!!
Message-Id: <20090205013042.C833EFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 17:30:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK on the change, though looks different if you put __ptrace_detach in
ptrace.c with the earliar patch, as I suggest.  Also, I think this warrants
a comment for the release_task call mentioning briefly what it means:

	/*
	 * The flag means __ptrace_detach() determined that this child
	 * was a zombie that should have been auto-reaped already.
	 * Don't leak it.
	 */
	if (unlikely(dead))
		release_task(child);


Thanks,
Roland

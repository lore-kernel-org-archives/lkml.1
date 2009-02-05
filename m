Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZBEOoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZBEOoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZBEOn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:43:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44487 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZBEOn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:43:58 -0500
Date: Thu, 5 Feb 2009 15:41:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ptrace: fix possible zombie leak on PTRACE_DETACH
Message-ID: <20090205144135.GB20953@redhat.com>
References: <20090129042923.GA5118@redhat.com> <20090205013042.C833EFC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205013042.C833EFC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Roland McGrath wrote:
>
> ACK on the change, though looks different if you put __ptrace_detach in
> ptrace.c with the earliar patch, as I suggest.  Also, I think this warrants
> a comment for the release_task call mentioning briefly what it means:
> 
> 	/*
> 	 * The flag means __ptrace_detach() determined that this child
> 	 * was a zombie that should have been auto-reaped already.
> 	 * Don't leak it.
> 	 */
> 	if (unlikely(dead))
> 		release_task(child);

OK, will add this to the cleanup patch too.

Oleg.


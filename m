Return-Path: <linux-kernel-owner+w=401wt.eu-S1762371AbZEGJfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762371AbZEGJfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbZEGJcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:32:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762727AbZEGJcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:32:53 -0400
Date: Thu, 7 May 2009 11:31:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507093124.GA355@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507090459.GE19133@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> The design around that code does not seem to be very consistent.
> 
> One solution would be for the default "plain Linux" security 
> module to have a stock ->ptrace_access_check() that does the 
> current ptrace_may_access() check, and then procfs could be 
> updated to use that callback - instead of calling into the ptrace 
> core code directly.

hm, that's not a good idea, as we'd have an unnecessary indirect 
call even in the common case where the higher-level ptrace checks 
deny a request via -EPERM early on already.

So it's all designed fine and what we need is the rename plus the 
elimination of the bool.

	Ingo

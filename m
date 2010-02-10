Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0BJOTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 09:19:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab0BJOTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:19:50 -0500
Date: Wed, 10 Feb 2010 15:18:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 2/4] x86, ptrace: regset extensions to support xstate
Message-ID: <20100210141836.GA23861@redhat.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com> <20100209202502.216592031@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209202502.216592031@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static inline int user_regset_copyout(unsigned int *pos, unsigned int *count,
				      void **kbuf,
				      void __user **ubuf, const void *data,
				      const int start_pos, const int end_pos)
{
	if (*count == 0)
		return 0;
	BUG_ON(*pos < start_pos);
	if (end_pos < 0 || *pos < end_pos) {
		unsigned int copy = (end_pos < 0 ? *count
				     : min(*count, end_pos - *pos));
		data += *pos - start_pos;
                            ^^^
Is it correct? Shouldn't it be

		data += *pos + start_pos;

?

Currently this doesn't matter, start_pos == 0 always. In fact I don't
understand why do we need this arg. In unlikely case the caller wants
to copy the part of *data, it can adjust data/end_pos itself.

Oleg.


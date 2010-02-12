Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0BLQAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:00:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab0BLQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:00:46 -0500
Date: Fri, 12 Feb 2010 16:59:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       peter.lachner@intel.com
Subject: Re: [patch v3 2/2] ptrace: Add support for generic
	PTRACE_GETREGSET/PTRACE_SETREGSET
Message-ID: <20100212155955.GA16870@redhat.com>
References: <20100211195058.071883111@sbs-t61.sc.intel.com> <20100211195614.886724710@sbs-t61.sc.intel.com> <20100212035606.119B3C821@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212035606.119B3C821@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Roland McGrath wrote:
>
> > +static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
> > +			 struct iovec *kiov)
> > +{
> > +	const struct user_regset_view *view = task_user_regset_view(task);
> > +	const struct user_regset *regset = find_regset(view, type);
> > +	int regset_no;
> > +
> > +	if (!regset || (kiov->iov_len % regset->size) != 0)
> > +		return -EIO;
>
> My inclination would be to diagnose these more specifically.

Agreed.

Otherwise I think the patch is fine.

Oleg.


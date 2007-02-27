Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXB0Ihx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXB0Ihx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXB0Ihx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:37:53 -0500
Received: from mail.screens.ru ([213.234.233.54]:47801 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbXB0Ihv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:37:51 -0500
Date: Tue, 27 Feb 2007 11:37:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070227083741.GA85@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <200702261928.19274.rjw@sisk.pl> <20070226212554.GA93@tv-sign.ru> <200702270131.25656.rjw@sisk.pl> <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Aneesh Kumar wrote:
>
> >+static inline void freezer_do_not_count(void)
> >+{
> >+       current->flags |= PF_FREEZER_SKIP;
> >+}
> >+
> >+/*
> >+ * Tell the freezer to count this task as freezeable again and if it's a 
> >user
> >+ * space one, try to freeze it
> >+ */
> >+static inline void freezer_count(void)
> >+{
> >+       current->flags &= ~PF_FREEZER_SKIP;
> >+       if (current->mm)
> >+               try_to_freeze();
> >+}
> >+
> 
> 
> This means that we are not going to wait for the kernel thread
> (Parent) to freeze. I guess what vatsa suggested in previous mail is
> better.

Not only better, but correct. This is very simple: if we set PF_FREEZER_SKIP,
we must call try_to_freeze(), otherwise we confuse the freezer.

Oleg.


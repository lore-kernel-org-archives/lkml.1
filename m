Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbXFEVNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbXFEVNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765743AbXFEVNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:13:11 -0400
Received: from www.osadl.org ([213.239.205.134]:44637 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765723AbXFEVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:13:09 -0400
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070605210028.GA10084@ms2.inr.ac.ru>
References: <20070507144351.GA12302@ms2.inr.ac.ru>
	 <20070523072609.GC6859@elte.hu> <20070523115159.GA30251@ms2.inr.ac.ru>
	 <1181060711.4404.114.camel@chaos> <20070605173949.GA27618@ms2.inr.ac.ru>
	 <1181069306.4404.145.camel@chaos> <1181070953.4404.149.camel@chaos>
	 <20070605210028.GA10084@ms2.inr.ac.ru>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 23:13:06 +0200
Message-Id: <1181077986.4404.165.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 01:00 +0400, Alexey Kuznetsov wrote:
> Hello!
> 
> > We actually need to do something about this, as we might loop for ever
> > there. The robust cleanup code can fail (e.g. due to list corruption)
> > and we would see exit_state != 0 and the OWNER_DIED bit would never be
> > set, so we are stuck in a busy loop.
> 
> Yes...
> 
> It is possible to take read_lock(&tasklist_lock) before:

We really want to avoid the tasklist_lock at all. It's not trivial, but
I think it's doable. I send you a patch to test tomorrow morning when my
brain recovered from looking at that code :)

	tglx




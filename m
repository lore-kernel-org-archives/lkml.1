Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbYHDWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbYHDWDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYHDWCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:02:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55079
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755813AbYHDWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:02:52 -0400
Date: Mon, 04 Aug 2008 15:02:49 -0700 (PDT)
Message-Id: <20080804.150249.71509974.davem@davemloft.net>
To: tony.luck@intel.com
Cc: nacc@us.ibm.com, mingo@elte.hu, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
From: David Miller <davem@davemloft.net>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
	<57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com>
	<57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Mon, 4 Aug 2008 15:00:47 -0700

> > I'd bet resonable sums of money that we are (once again) accessing
> > per-cpu variables in code before ia64 has a chance to initialize
> > things so that they can actually work. :-(
> 
> I tried this simple hack to check ... per-cpu variables are
> not usable until cpu_init() sets up the "ar.k3" register on
> ia64.  So this hack checks to see if it is set before calling
> cpu_clock():

Can you guys on IA64 possibly set ar.k3 simply to zero or to some
other similar value which cancels out the per-cpu computation?

That's what sparc64 and other platforms do.

Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXGLNIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXGLNIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762823AbXGLNIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:08:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:51681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759011AbXGLNIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:08:23 -0400
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Immunize rcu_dereference() against crazy compiler writers
References: <20070712010058.GA30869@linux.vnet.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Jul 2007 16:03:19 +0200
In-Reply-To: <20070712010058.GA30869@linux.vnet.ibm.com>
Message-ID: <p73hco9yb14.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> Turns out that compiler writers are a bit more aggressive about optimizing
> than one might expect.  This patch prevents a number of such optimizations
> from messing up rcu_deference().  This is not merely a theoretical
> problem, as evidenced by the rmb() in mce_log().

Don't think that's an improvement. rmb() at least is known to work
reliable to prevent such reordering. Memory barriers are well
documented in the gcc documentation. Who knows about volatile?  The
volatile semantics have been traditionally unclear and shakey.
The C standard doesn't make much guarantees and i don't think 
gcc does either.

If anything you might want to embedd rmb(); in a statement expression
in rcu_deference instead.

-Andi

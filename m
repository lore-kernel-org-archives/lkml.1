Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXCGJKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXCGJKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422637AbXCGJKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:10:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422636AbXCGJKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:10:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@openvz.org>
X-Fcc: ~/Mail/utrace
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace regressions (was: -mm merge plans for 2.6.21)
In-Reply-To: Alexey Dobriyan's message of  Wednesday, 21 February 2007 16:37:42 +0300 <20070221133742.GA11162@localhost.sw.ru>
X-Windows: more than enough rope.
Message-Id: <20070307091032.483341801C4@magilla.sf.frob.com>
Date: Wed,  7 Mar 2007 01:10:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Feb 17, 2007 at 06:35:31PM -0800, Roland McGrath wrote:
> > > Looking at mainline x86_64 ptrace code I think hole for u_debugreg[4]
> > > and [5] is also needed.
> >
> > It's not.  The utrace_regset for the debugregs already has that behavior
> > for those two words, so mapping all 8 uarea words to the regset is fine.
> 
> Sorry, I don't get it. Choosing segment from x86_64_uarea is done before
> calling regset->set and regset->get as well as before zero-filling. No
> segment for u_debugreg[4] and [5] means -EIO before segment handlers
> will have a chance to be called.
> 
> Do you want to consolidate these two?
> 
>     {offsetof(struct user, u_debugreg[0]), offsetof(struct user, u_debugreg[4]), 3, 0},
>     {offsetof(struct user, u_debugreg[6]), offsetof(struct user, u_debugreg[8]), 3, 6 * sizeof(long)},

Oops!  I was misremembering what was in x86_64_uarea when I wrote that.
I've indeed fixed it to match what I thought it was:

	{offsetof(struct user, u_debugreg[0]),
	 offsetof(struct user, u_debugreg[8]), 3, 0},


Thanks,
Roland

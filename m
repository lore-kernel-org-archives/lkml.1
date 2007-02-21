Return-Path: <linux-kernel-owner+w=401wt.eu-S1161221AbXBUNab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161221AbXBUNab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161231AbXBUNaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:30:30 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:48845 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161221AbXBUNaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:30:30 -0500
Date: Wed, 21 Feb 2007 16:37:42 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace regressions (was: -mm merge plans for 2.6.21)
Message-ID: <20070221133742.GA11162@localhost.sw.ru>
References: <20070213153521.GA6036@localhost.sw.ru> <20070218023531.626D11800E4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218023531.626D11800E4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:35:31PM -0800, Roland McGrath wrote:
> > Looking at mainline x86_64 ptrace code I think hole for u_debugreg[4]
> > and [5] is also needed.
>
> It's not.  The utrace_regset for the debugregs already has that behavior
> for those two words, so mapping all 8 uarea words to the regset is fine.

Sorry, I don't get it. Choosing segment from x86_64_uarea is done before
calling regset->set and regset->get as well as before zero-filling. No
segment for u_debugreg[4] and [5] means -EIO before segment handlers
will have a chance to be called.

Do you want to consolidate these two?

    {offsetof(struct user, u_debugreg[0]), offsetof(struct user, u_debugreg[4]), 3, 0},
    {offsetof(struct user, u_debugreg[6]), offsetof(struct user, u_debugreg[8]), 3, 6 * sizeof(long)},


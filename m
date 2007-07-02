Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbXGBXVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbXGBXVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbXGBXVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:21:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbXGBXVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:21:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18057.34926.788402.262293@cargo.ozlabs.ibm.com>
Date: Tue, 3 Jul 2007 09:21:18 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       kgdb-bugreport@lists.sourceforge.net,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
In-Reply-To: <46890F8D.3080807@windriver.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<200706291432.10128.m.kozlowski@tuxland.pl>
	<4685010C.4000108@ru.mvista.com>
	<4689025C.8000001@windriver.com>
	<46890A52.6020201@ru.mvista.com>
	<46890F8D.3080807@windriver.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel writes:

> I suppose the argument could be made to remove the check in the compiled 
> file, but it does serve as a way to protect kgdb for now if someone 
> tries to hard compile in xmon and kgdb.  Completely unpredictable 
> results will occur with the debugger unless some pieces are fixed.  I 
> would rather make sure until that happens there is no way head down the 
> rat hole.

It should all work provided kgdb plays nicely.  We used to be able to
compile in both xmon and kdb and select at runtime which one gets
used.

> That issue aside would it be useful to have xmon+kgdb?  After having 
> looked at the hook points for xmon, if a command was added to xmon to 
> provide an "detach" it would be easy enough to have kgdb and xmon in the 
> same kernel.  Obviously only one or the other can be used at any given time.

Well, xmon_init(0) will do a detach.  However, I don't see that it is
needed; there is plenty of flexibility to choose to have xmon or not
using the CONFIG_XMON_DEFAULT config option and the xmon= boot command
line option.

Paul.

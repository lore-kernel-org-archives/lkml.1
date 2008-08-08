Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYHHC2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYHHC2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYHHC2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:28:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60176 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYHHC2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:28:33 -0400
Date: Fri, 8 Aug 2008 04:29:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Keith Owens <kaos@ocs.com.au>, Andi Kleen <andi@firstfloor.org>,
       Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808022916.GM24801@one.firstfloor.org>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808011500.GA531@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> panic() is the only place where kdump gets a chance to run first and
> panic notifiers are not executed.

To be fully clear panic() that is called outside oops/exception context

s/panic/die notifiers/

> 
> To me so far only in kernel debugger seems to be a reasonable candiate

Yes a kernel debugger should be able to hook into panic()

In fact it can do that already by just setting a break point,
but clearly having a real notifier is preferable.

The use case would be then that the kernel debugger would
have some command to trigger a dump.

> which needs to run before kdump after a panic event. If a debugger
> is really getting merged into the kernel, then I think debugger can

kgdb is already merged. Also the x86 notifiers are general
enough that there are a couple of debuggers floating around
that are just using existing interfaces (as in need very little in terms
of core patching) 

> put a hook in the panic() before kdump. Wouldn't this solve the problem?

Yes it would, but right now there is no such hook. Also if there 
was such a hook kdump could use it like everyone else.  

There's a priority scheme in notifiers so you can still run usually last.

-Andi

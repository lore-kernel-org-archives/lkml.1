Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXEIKpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXEIKpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbXEIKpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:45:01 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33179 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXEIKpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:45:00 -0400
Message-ID: <4641A5F1.5080901@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 12:44:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: torvalds@linux-foundation.org, rjw@sisk.pl, James.Bottomley@SteelEye.com,
       aneesh.kumar@gmail.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       ego@in.ibm.com, greg@kroah.com, mingo@elte.hu, neilb@suse.de,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz,
       vatsa@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel
 threads
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net>
In-Reply-To: <200705090934.l499YTvX019783@shell0.pdx.osdl.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add try_to_freeze() calls to the remaining kernel threads that do not call
> try_to_freeze() already, although they set PF_NOFREEZE.
> 
> In the future we are going to replace PF_NOFREEZE with a set of flags that
> will be set to indicate in which situations the task should not be frozen (for
> example, there can be a task that should be frozen for the CPU hotplugging and
> should not be frozen for the system suspend).  For this reason every kernel
> thread should be able to freeze itself (ie.  call try_to_freeze()), so that it
> can be frozen whenever necessary.

A few questions:

Does try_to_freeze()'s kerneldoc document that try_to_freeze() is a
no-op sometimes but should nevertheless be called for this and that
reason?  (I don't know the entire patch series.)

Why add no-op-try_to_freeze() everywhere now, instead of adding it later
when it will actually be needed?  (I.e. "in the future".)

Can we please have a future where no device driver has to care if and
when and how to freeze its threads?
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/

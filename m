Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZIGO0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZIGO0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZIGO0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:26:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:56405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZIGO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:26:08 -0400
Subject: Re: [rfc] lru_add_drain_all() vs isolation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090907141818.GA8394@redhat.com>
References: <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
	 <1252232289.29247.11.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC482@exchange.ZeugmaSystems.local>
	 <1252249790.13541.28.camel@marge.simson.net>
	 <1252311463.7586.26.camel@marge.simson.net>
	 <1252321596.7959.6.camel@laptop> <20090907133544.GA6365@redhat.com>
	 <1252331599.7959.33.camel@laptop>  <20090907141818.GA8394@redhat.com>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 16:25:54 +0200
Message-Id: <1252333554.7959.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 16:18 +0200, Oleg Nesterov wrote:

> > flush_workqueue() could limit itself to cpus that had work queued since
> > the last flush_workqueue() invocation, etc.
> 
> But "work queued since the last flush_workqueue() invocation" just means
> "has work queued". Please note that flush_cpu_workqueue() does nothing
> if there are no works, except it does lock/unlock of cwq->lock.
> 
> IIRC, flush_cpu_workqueue() has to lock/unlock to avoid the races with
> CPU hotplug, but _perhaps_ flush_workqueue() can do the check lockless.
> 
> Afaics, we can add the workqueue_struct->cpu_map_has_works to help
> flush_workqueue(), but this means we should complicate insert_work()
> and run_workqueue() which should set/clear the bit. But given that
> flush_workqueue() should be avoided anyway, I am not sure.

Ah, indeed. Then nothing new would be needed here, since it will indeed
not interrupt processing on the remote cpus that never queued any work.




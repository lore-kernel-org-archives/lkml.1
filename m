Return-Path: <linux-kernel-owner+w=401wt.eu-S1946050AbXEAW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946050AbXEAW45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946048AbXEAW45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:56:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:60948 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946050AbXEAW44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:56:56 -0400
Date: Wed, 2 May 2007 02:56:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: libata-core.c: unsafe cancel_delayed_work() usage?
Message-ID: <20070501225654.GA190@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru> <20070426125838.GC12892@in.ibm.com> <20070427184258.62794053.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427184258.62794053.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Andrew Morton wrote:
>
> It'd be good if people could take some time to sit down and re-review the
> code which we presently have.  I plan on sending it all off for 2.6.22 and
> there might be some glitches but it seems to have a good track record so
> far.

Alan, the usage of cancel_delayed_work() in drivers/ata/libata-core.c looks
suspicious to me, both ->hotplug_task and ->port_task can re-arm themselves,
so cancel_delayed_work + flush_workqueue (or cancel_work_sync) is not enough.

Could you confirm/nack my understanding?

Oleg.


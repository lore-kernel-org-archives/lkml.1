Return-Path: <linux-kernel-owner+w=401wt.eu-S1946058AbXEAXfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946058AbXEAXfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946061AbXEAXfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:35:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53297 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946058AbXEAXfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:35:18 -0400
Message-ID: <4637CEAA.7070102@garzik.org>
Date: Tue, 01 May 2007 19:35:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: libata-core.c: unsafe cancel_delayed_work() usage?
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru> <20070426125838.GC12892@in.ibm.com> <20070427184258.62794053.akpm@linux-foundation.org> <20070501225654.GA190@tv-sign.ru>
In-Reply-To: <20070501225654.GA190@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/27, Andrew Morton wrote:
>> It'd be good if people could take some time to sit down and re-review the
>> code which we presently have.  I plan on sending it all off for 2.6.22 and
>> there might be some glitches but it seems to have a good track record so
>> far.
> 
> Alan, the usage of cancel_delayed_work() in drivers/ata/libata-core.c looks
> suspicious to me, both ->hotplug_task and ->port_task can re-arm themselves,
> so cancel_delayed_work + flush_workqueue (or cancel_work_sync) is not enough.
> 
> Could you confirm/nack my understanding?

For all rearming workqueues, one must use cancel-rearming-blahblah.

	Jeff




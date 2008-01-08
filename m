Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYAHTv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYAHTv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYAHTvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:51:21 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:46701 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbYAHTvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:51:20 -0500
X-Greylist: delayed 2642 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 14:51:20 EST
Date: Tue, 8 Jan 2008 21:06:38 +0200
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: jbeulich@novell.com, proski@gnu.org
Subject: Replacement for page fault notifiers?
Message-ID: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the commit "x86: optimize page faults like all other achitectures and
kill notifier cruft" by Christoph Hellwig removed the page fault
notifiers (e.g. register_page_fault_notifier()) completely in 2.6.24.
Mmio-trace [1] is using them for tracking memory mapped IO, and also
other people have mentioned they need it [2,3].

This is roughly how I understand mmio-trace is working. In a loadable
kernel module calls to __ioremap() are diverted to an mmio-trace
specific function. The function calls the real __ioremap() and marks
the returned pages as not present. Access to the mapped IO memory
causes a page fault. Mmio-trace's page fault handler marks the page
present, records the event, single-steps the faulting instruction, and
finally marks the page as not present again.

- Is there anything coming to replace register_page_fault_notifier()?
- Has someone found another way to accomplish the same without patching
the kernel?
- Should I start writing a patch to bring back the notifiers, based on
the commit that removed them?

People started to complain to me that mmio-trace does not compile for
2.6.24. At least the Nouveau project is a regular user of mmio-trace
for reverse-engineering, and the tool should be easy to use. Therefore
I would prefer not to force casual contributors to patch their kernels
as it might be too much for some. I am hoping that 2.6.25, if not
2.6.24, would contain a mechanism to accomplish what I need.

I am not a subscriber, so please keep me in CC. Also I CC'd the people
who wrote about the same issue in the past.

Thanks.


[1] http://nouveau.freedesktop.org/wiki/MmioTrace
[2] http://marc.info/?l=linux-kernel&m=119540769014745&w=2
[3] http://article.gmane.org/gmane.linux.kernel/609521

-- 
Pekka Paalanen
http://www.iki.fi/pq/

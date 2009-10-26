Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZJZWNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZJZWNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZJZWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:13:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:12166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZJZWM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:12:58 -0400
X-ExtLoop1: 1
Subject: Re: [Bug #14375] Intel(R) I/OAT DMA Engine init failed
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <a4423d670910261457o2e1ccb7t768199dfd9985270@mail.gmail.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.bIH.qre5KB@chimera>
	 <a4423d670910261457o2e1ccb7t768199dfd9985270@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 15:13:02 -0700
Message-Id: <1256595182.19520.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 14:57 -0700, Alexander Beregalov wrote:
> 2009/10/26 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14375
> > Subject         : Intel(R) I/OAT DMA Engine init failed
> > Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> > Date            : 2009-10-02 9:46 (25 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125447680016160&w=4
> > Handled-By      : Dan Williams <dan.j.williams@intel.com>
> > Patch           : http://patchwork.kernel.org/patch/51808/
> 
> When I patch reiserfs the bug goes to libata, it means ioatdma works
> and libata does not. It looks like inaccurate work with memory
> somewhere, but I do not know how to find it.
> I cannot reproduce it since 2.6.32-rc3 and I do not see any bugs since then.

If it helps the debug, the symptom seems to be that all interrupts get
turned off.  Neither the normal device completion interrupt nor the
completion watchdog timer fire before the self test timeout.  It seems
something else re-enables interrupts eventually, but we know they were
at least disabled for 3 seconds.  An unmatched spin_unlock_irq in an
async initialization path perhaps?

--
Dan



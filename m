Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZFHQP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZFHQP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZFHQPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:15:49 -0400
Received: from mail.vyatta.com ([76.74.103.46]:39802 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbZFHQPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:15:47 -0400
Date: Mon, 8 Jun 2009 09:15:44 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dan Williams" <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13116] Can't boot with nosmp
Message-ID: <20090608091544.53a94235@nehalam>
In-Reply-To: <D9VoutSOyXP.A.xm.Vb7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	<D9VoutSOyXP.A.xm.Vb7KKB@chimera>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Jun 2009 11:52:49 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13116
> Subject		: Can't boot with nosmp
> Submitter	: Stephen Hemminger <shemminger@vyatta.com>
> Date		: 2009-04-15 4:18 (54 days old)
> References	: http://marc.info/?l=linux-kernel&m=123976917817920&w=4
> Handled-By	: Dan Williams <dan.j.williams@intel.com>
> 
> 

I suspect this bit of code in dmaengine is the culprit:

	/* redistribute available channels */
	n = 0;
	for_each_dma_cap_mask(cap, dma_cap_mask_all)
		for_each_online_cpu(cpu) {
			if (num_possible_cpus() > 1)
				chan = nth_chan(cap, n++);
			else
				chan = nth_chan(cap, -1);

Why does num_possible_cpus() == 1 have to be a special case?
-- 

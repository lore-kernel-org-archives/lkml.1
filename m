Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbXH2EEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbXH2EEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXH2EDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:03:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbXH2EDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:03:53 -0400
Date: Wed, 29 Aug 2007 06:03:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: Linux 2.6.23-rc4, maxcpus=1 regression
Message-ID: <20070829040345.GA5260@elte.hu>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org> <20070829035554.GA838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829035554.GA838@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> maxcpus=1 fails to boot on my T60 laptop, it hangs in early bootup 
> (right after setting up the local APICs). I bisected it down to this 
> recent commit:
> 
> | commit 61ec7567db103d537329b0db9a887db570431ff4
> | Author: Len Brown <len.brown@intel.com>
> | Date:   Thu Aug 16 03:34:22 2007 -0400
> |
> |     ACPI: boot correctly with "nosmp" or "maxcpus=0"
> 
> reverting that commit makes the system boot again. I've attached the 
> .config.

i suspect it's due to this:

 -early_param("maxcpus=", maxcpus);
 +__setup("maxcpus=", maxcpus);

i'm quite sure maxcpus still needs to be an early-param.

	Ingo

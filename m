Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYHSW1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYHSW1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHSW1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:27:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60751 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbYHSW1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:27:22 -0400
Date: Tue, 19 Aug 2008 15:19:39 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Message-ID: <20080819221939.GC11599@us.ibm.com>
References: <20080804194646.GA17390@us.ibm.com> <57C9024A16AD2D4C97DC78E552063EA30844B26C@orsmsx505.amr.corp.intel.com> <20080813162553.GA5720@elte.hu> <20080813192909.GA31685@us.ibm.com> <57C9024A16AD2D4C97DC78E552063EA3084A65FD@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3084A65FD@orsmsx505.amr.corp.intel.com>
X-Operating-System: Linux 2.6.27-rc3 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.08.2008 [13:11:45 -0700], Luck, Tony wrote:
> > Well Peter's patch was tested-by me, so I know it fixes the problem on
> > the box I have access to, I'm verifying that -rc3 is ok.
> >
> > Tony, would you like me to test your patch in isolation (reverting
> > c1955a3d4762e7a9bf84035eb3c4886a900f0d15) to see if it also fixes it?
> 
> It would be nice to know ... I expect that you'll see crazy numbers
> for the timestamps on the first few printk()s without Peter's fix (I
> did on my system).

Sorry for the delay.

Yes, your patch in isolation (having reverted Peter's
c1955a3d4762e7a9bf84035eb3c4886a900f0d15) allows this box to boot
2.6.27-rc3 with CONFIG_PRINTK_TIME=y. As you noted, I did see some
oddities in the printk timings, where the values would go up then back
down, but nothing further out of the ordinary.

Thanks,
Nish

P.S. Should I start a separate thread on the messages I mentioned
earlier (but only in passing)?

[   32.593534] kernel unaligned access to 0xe000000644220466, ip=0xa000000100516fa1
[   32.601171] kernel unaligned access to 0xe00000064422046e, ip=0xa000000100516fa1
[   35.333273] kernel unaligned access to 0xe00000064451693e, ip=0xa000000100516fa1
[   35.340912] kernel unaligned access to 0xe000000644516942, ip=0xa000000100516fa1
[   35.348557] kernel unaligned access to 0xe000000644516946, ip=0xa000000100516fa1

Box seems fine even with those messages.

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

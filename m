Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZF3Tbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZF3Tbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZF3TbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:31:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbZF3TbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:31:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [rfc] do not place sub-threads on task_struct->children list
In-Reply-To: Oleg Nesterov's message of  Tuesday, 30 June 2009 01:08:41 +0200 <20090629230841.GA13024@redhat.com>
References: <20090622170437.GA4906@redhat.com>
	<20090624091316.73D0F4059B@magilla.sf.frob.com>
	<20090624152143.GB23848@redhat.com>
	<20090624185701.AA74C4059B@magilla.sf.frob.com>
	<20090624161111.GA27890@redhat.com>
	<20090624194239.A29174059B@magilla.sf.frob.com>
	<20090624171357.GA30435@redhat.com>
	<20090624205112.3EA944059B@magilla.sf.frob.com>
	<93ad5f3f0906252111n48742b9ax8dc2ad35b30f4292@mail.gmail.com>
	<20090629033852.GA14404@redhat.com>
	<20090629230841.GA13024@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090630193037.6CCE01C4@magilla.sf.frob.com>
Date: Tue, 30 Jun 2009 12:30:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently we add sub-threads to ->real_parent->children list. This
> buys nothing but slows down do_wait().
> 
> With this patch ->children contains only main threads (group leaders).
> The only complication is that forget_original_parent() should iterate
> over sub-threads by hand.

This seems right to me, though I'll admit I haven't really walked through
all the exit/reparent paths afresh with this in mind.

Note that this naturally suggests moving ->sibling to signal_struct.  (Of
course that can come later.)  The abuse of sibling in reparent_leader adds
a wrinkle to that, but off hand it looks like it could do the same with it
living in signal_struct with a bit of contortion.

Oh, and what about the de_thread() leader-replacement case?


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZJTVLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZJTVLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZJTVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZJTVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:11:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
In-Reply-To: Sebastian Andrzej Siewior's message of  Monday, 19 October 2009 21:30:58 +0200 <20091019193058.GA29613@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
	<20091019073358.GE17960@elte.hu>
	<20091019080239.GB25783@Chamillionaire.breakpoint.cc>
	<20091019180810.3CB751E@magilla.sf.frob.com>
	<20091019193058.GA29613@Chamillionaire.breakpoint.cc>
X-Windows: you'll envy the dead.
Message-Id: <20091020211116.2B76F81A3@magilla.sf.frob.com>
Date: Tue, 20 Oct 2009 14:11:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+#ifdef CONFIG_STACK_GROWSUP
> >+	return sp >= current->sas_ss_sp &&
> >+		sp - current->sas_ss_sp < current->sas_ss_size;
> 
> CONFIG_STACK_GROWSUP is wrong: If your stack grows up and sp ==
> sas_ss_sp + size than you are using the last entry in your sig stack
> which will be not recognized correctly. 

+		sp - current->sas_ss_sp <= current->sas_ss_size;

then?

> The case where sp == sas_ss_sp
> is also not detected correctly but this should not happen in real life.

So you say that sp==sas_ss_sp should not be considered "on the sig stack"?

> That is the PRE case which is the only relevant since we don't have any
> POST architectures. The check here produces the same results as my
> variant so it is okay :)
> So you prefer the smaller patch with comments around it?

Yes, I think it is far clearer and easier to read than what you posted.


Thanks,
Roland

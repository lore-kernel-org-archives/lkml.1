Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYHGBNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYHGBNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 21:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYHGBNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 21:13:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42207 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYHGBNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 21:13:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	<m1hc9yjb7x.fsf@frodo.ebiederm.org>
	<86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	<m1y739j2z8.fsf@frodo.ebiederm.org>
	<20080807002638.04699eac@lxorguk.ukuu.org.uk>
Date: Wed, 06 Aug 2008 18:02:18 -0700
In-Reply-To: <20080807002638.04699eac@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Thu, 7 Aug 2008 00:26:38 +0100")
Message-ID: <m18wv9iqn9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0579]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> A lot of these are range checks so could be replaced by a single
> valid_irq(irq) test.

Yes.  My first impression was that with NR_IRQS dead valid_irq could
easily become. #define valid_irq(irq) ((irq) != 0) However thinking
just a little more since ultimately we will know which irqs have
something hooked up to them we might actually be able to say something
more interesting.  So I guess actually having a valid irq function
makes sense.  Instead of doing the idiomatic if (irq) logic inline.

Eric


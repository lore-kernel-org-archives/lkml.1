Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZDENlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZDENlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 09:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZDENlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 09:41:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZDENlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 09:41:35 -0400
Date: Sun, 5 Apr 2009 15:41:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Meelis Roos <mroos@linux.ee>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange MTRR on 2.6.29-git
Message-ID: <20090405134109.GA24782@elte.hu>
References: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee> <86802c440904011143i65d99bd8x7a296f616f6bfccc@mail.gmail.com> <Pine.SOC.4.64.0904050953480.2958@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.SOC.4.64.0904050953480.2958@math.ut.ee>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Meelis Roos <mroos@linux.ee> wrote:

> > > reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
> > > reg01: base=0x020000000 (  512MB), size=    1MB, count=1: write-back
> > > reg02: base=0x020000000 (  512MB), size=    1MB, count=1: uncachable
> > > reg03: base=0x0f2000000 ( 3872MB), size=   32MB, count=2: write-combining
> > > reg04: base=0x0f8000000 ( 3968MB), size=   64MB, count=1: write-combining
> 
> > that is original setting by BIOS.
> > it should be ok.
> > if you like, could try to enable
> > 
> > CONFIG_MTRR=y
> > CONFIG_MTRR_SANITIZER=y
> > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> > 
> > it could do the clean up for you.
> 
> Thank you, it did clean it up:
> 
> reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
> reg01: base=0x0f2000000 ( 3872MB), size=   32MB, count=2: write-combining
> reg02: base=0x0f8000000 ( 3968MB), size=   64MB, count=1: write-combining
> 
> and it removed the overlapping MTRR-s altogether since there was 
> no RAM described t be here. Seems to work fine.
 
ok, great.

I'm wondering whether CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT should be 
1 by default in the future.

	Ingo

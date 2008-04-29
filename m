Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYD2T3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYD2T3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYD2T3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:29:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35873 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbYD2T3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:29:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com
References: <200801192045.17291.yinghai.lu@sun.com>
	<200801202256.48365.yinghai.lu@sun.com>
	<20080122165125.GA17992@elte.hu>
	<200801221623.20861.yinghai.lu@sun.com>
	<20080426035614.a30afb17.akpm@linux-foundation.org>
	<48132665.8050202@googlemail.com>
	<86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
	<m17ieh4zuo.fsf@frodo.ebiederm.org> <20080429103150.GJ23198@elte.hu>
	<m1ej8o4liv.fsf@frodo.ebiederm.org>
	<86802c440804291140k7e96b6cftbb350b8fc72103f@mail.gmail.com>
Date: Tue, 29 Apr 2008 12:19:43 -0700
In-Reply-To: <86802c440804291140k7e96b6cftbb350b8fc72103f@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 29 Apr 2008 11:40:51 -0700")
Message-ID: <m18wyw31v4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>>  The potential problem isn't while we reprogram the MTRRs, the potential
>>  problem is mapping the SMM area uncachable.  In which case we will
>>  make each SMM interrupt drastically slower.  Which can have all kinds of
>>  unpleasant side effects.
>
> and ACPI area too.

True but at least that one is visible.

> that only try to make the continuous to discrete layout. and still try
> to cover all that is (WBs - UC) directly with WB.
> only thing is that could run out of MTRR..., and mtrr_gran_size is
> used to avoid that.
> then some RAM that is less than mtrr_gran_size could be dumped.
> so mtrr_gran_size could do sth.
> anyway this patch only can meet one end.
> for example Mika Fischer's system doesn't need to trim any RAM in MTRR.
> but for Gabriel's system may need to trim some RAM in MTRR.

Right.  Ram trimming (changing memory from WB to UC) is the potential
problem.

See my other post, in short I think we can address safely address all
of the systems where the only problem is the selection of MTRRs by the
BIOS.

Then have an option (mtrr_chunk_size) for RAM trimming that is
off by default.

It is good to hear that some users and some systems
get the benefit without trimming.

Eric

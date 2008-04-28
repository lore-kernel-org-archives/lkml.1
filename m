Return-Path: <linux-kernel-owner+w=401wt.eu-S965464AbYD1SIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965464AbYD1SIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765875AbYD1SIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:08:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45817 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764945AbYD1SIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:08:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com
References: <200801192045.17291.yinghai.lu@sun.com>
	<200801202256.48365.yinghai.lu@sun.com>
	<20080122165125.GA17992@elte.hu>
	<200801221623.20861.yinghai.lu@sun.com>
	<20080426035614.a30afb17.akpm@linux-foundation.org>
	<48132665.8050202@googlemail.com>
	<86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
Date: Mon, 28 Apr 2008 11:07:59 -0700
In-Reply-To: <86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 26 Apr 2008 18:05:39 -0700")
Message-ID: <m17ieh4zuo.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Sat, Apr 26, 2008 at 5:56 AM, Gabriel C <nix.or.die@googlemail.com> wrote:

> another continuous MTRR mapping.
>
> several months ago, we were talking about modifying MTRR. but Eric
> said that is not safe because acpi and smi...

I think it was Andi who spotted that originally, and yes I do think it
is a pretty horrific failure mode.  Reprogramming the MTRRs requires
full knowledge of the hardware and what is going on that we don't
always have.  PAT support has just been merged, and using that only
requires knowledge about the region whose attributes we intend to change.

So lets concentrate on PAT to solve contiguous MTRR region problems.

We can upgrade UC to WC with pat.  As well as demote WB to UC or WC.
So for those regions we know about we should be in good shape.

In a slightly related vein.  Trimming the memory we consider usable by
looking at MTRRs and if a region is not WB not considering it RAM
sounds like a very reasonable work around for one class of BIOS bugs.

Eric

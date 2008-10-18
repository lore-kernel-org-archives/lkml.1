Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbYJRHPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbYJRHPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYJRHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:15:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYJRHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:15:44 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series
From: Andi Kleen <andi@firstfloor.org>
References: <20081007210056.GA5802@linux-os.sc.intel.com>
	<48EBCFF8.6050500@zytor.com>
	<20081007214920.GA17439@linux-os.sc.intel.com>
	<48EBEA97.9020404@zytor.com>
	<7E82351C108FA840AB1866AC776AEC4637B798D6@orsmsx505.amr.corp.intel.com>
	<48F8F1DB.9030202@zytor.com>
	<7E82351C108FA840AB1866AC776AEC4637B799FB@orsmsx505.amr.corp.intel.com>
	<48F91673.6090901@zytor.com>
Date: Sat, 18 Oct 2008 09:15:39 +0200
In-Reply-To: <48F91673.6090901@zytor.com> (H. Peter Anvin's message of "Fri, 17 Oct 2008 15:49:23 -0700")
Message-ID: <87vdvqjrvo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Pallipadi, Venkatesh wrote:
>>>>
>>> I guess I'm a bit confused about the tradeoff of CLFLUSH versus simply
>>> disabling MWAIT.  This is a relatively recent processor and so
>>> optimizing matters (if this was a P4 I would be more worried about what
>>> has least impact on the kernel as a whole.)
>> As of now this is only for a limited models of CPUs (MP CPUs)
>> and not a norm. It is a errata on this CPU and not
>> something that is going to become architectural.
>>
>
> Yes, I understand.  However, there is still the option to disable
> MWAIT, and the question is still open if it makes sense.

This would mean falling back to the IO port interface for deeper 
C states. Even with the CLFLUSH MWAIT is a much better (and I believe 
faster) interface.

-Andi
-- 
ak@linux.intel.com

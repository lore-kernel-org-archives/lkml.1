Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYD2WTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYD2WTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbYD2WTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:19:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55583 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401AbYD2WTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:19:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mika Fischer" <mika.fischer@zoopnet.de>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281244.56938.yhlu.kernel@gmail.com>
	<200804281316.14168.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
	<m1wsmg32qk.fsf@frodo.ebiederm.org>
	<86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
	<m1abjcz9ow.fsf@frodo.ebiederm.org>
	<86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
Date: Tue, 29 Apr 2008 15:14:33 -0700
In-Reply-To: <86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 29 Apr 2008 14:57:48 -0700")
Message-ID: <m11w4oxq9i.fsf@frodo.ebiederm.org>
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
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Tue, Apr 29, 2008 at 1:29 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>  > (less memory + fast X) or  (more 8M RAM + slow...)
>>
>>  Yes. That is the basic question.  Not all X drivers need it and
>>  potentially the current kernel drm modules can use the
>>  PAT infrastructure that has been merged.
>>
>>  Further a SMM monitor running 100 times or more slower may cause
>>  problems if SMM mode is entered frequently, slowing down the entire
>>  system not just X.
>>
>>  So if you don't have X or you have a crazy SMM monitor this can
>>  be an issue.
>
> agreed. so that feature is compiled in but disable by default.
>
> BTW: is any chance for OS to disable SMI etc? to verify is the
> unstatbility is caused by SMI?

Not in general no.  Frequently you can get at the registers that
will enable/disable an SMI but that is chipset specific.

Think of SMM mode is a lightweight hypervisor that we can't get rid
of, if you want to understand the worst case.

In theory SMM mode is completely unnecessary as soon as we enable
ACPI.  In practice ACPI appears to frequently trap into SMM mode.

Eric


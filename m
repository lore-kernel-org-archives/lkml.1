Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZBVWhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZBVWhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZBVWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:37:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60675 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZBVWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:37:03 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 22 Feb 2009 14:37:20 -0800
In-Reply-To: <200902221837.49396.rjw@sisk.pl> (Rafael J. Wysocki's message of "Sun\, 22 Feb 2009 18\:37\:48 +0100")
Message-ID: <m1skm6cd3z.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: rjw@sisk.pl, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 0/2] Rework disabling of interrupts during suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Moreover, the real purpose of these changes is to be able to execute the
> "late" suspend and "early" resume device callbacks with timer interrupts
> enabled, so that they can use mutexes etc.  However, x86 currently doesn't set
> the IRQF_TIMER flag and I need to make it do so before going further in this
> direction and changing the PCI PM framework to take advantage of the $subject
> changes, for example.  So, I need to know how to modify x86 timer code so that
> the IRQF_TIMER flag is set by it.

How does this sync with the ACPI requirement that the it's late suspend MUST
happen with irqs disabled?

Eric

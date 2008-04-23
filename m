Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYDWMtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYDWMtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYDWMtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:49:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53026 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYDWMtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:49:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kdb@oss.sgi.com, vgoyal@redhat.com, kexec@lists.infradead.org,
       Keith Owens <kaos@ocs.com.au>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com, bwalle@suse.de,
       k-miyoshi@cb.jp.nec.com
References: <480F1957.2070609@ah.jp.nec.com>
Date: Wed, 23 Apr 2008 05:48:53 -0700
In-Reply-To: <480F1957.2070609@ah.jp.nec.com> (Takenori Nagano's message of
	"Wed, 23 Apr 2008 20:11:19 +0900")
Message-ID: <m1wsmoohxm.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0025]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/3] add new notifier function ,take4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takenori Nagano <t-nagano@ah.jp.nec.com> writes:

> Hi,
>
> changelog take3 -> take4
>
> - Rebased 2.6.25-mm1
> - Add a document
> - Add kdump on panic_notifier
>
> These patches add new notifier function and implement it to panic_notifier_list.
> We used the hardcoded notifier chain so far, but it was not flexible. New
> notifier is very flexible, because user can change a list of order by control
> files.
>
> And, third patch moves crash_kexec() to panic_notifier. It helps us to do
> something before taking a crash dump. It's useful for some RAS tools developer.
> If you want to use it, you have to set config option DUMP_ON_PANIC_NOTIFIER to
> Y. Default value of DUMP_ON_PANIC_NOTIFIER is N.
> If you set DUMP_ON_PANIC_NOTIFIER to N, kdump has no difference before.

NAK.

Reasonable alternatives have been suggested.  No rebuttal has been given.
Just buggy patches with insufficient description of what you are doing
and why.

I am tired of seeing the same patch come up again and again without even
all of the easy problems that are pointed out addressed, much less the
design issues considered or addressed.

I see no evidence that we need this mechanism to achieve any of
the goals proposed.

This mechanism drastically reduces the maintainability of the
kexec on panic code as it makes the code path indiscoverable
and thus unreviewable.

This mechanism gives an unnecessary and confusing policy control
to users when we should be able to auto-tune based on the situation.

CONFIGURABILITY IS BAD in this context.

I think this entire approach is a BAD IDEA.  Please go back to
the drawing board.  Please describe the specific problems you
are trying to solve and why the existing mechanisms can not be
made to work and we can work with you.

Eric

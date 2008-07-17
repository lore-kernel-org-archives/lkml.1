Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbYGQRwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbYGQRwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbYGQRwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:52:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56462 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYGQRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:52:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org
References: <487F5D6B.1090007@hozac.com> <487F5EDB.1000008@openvz.org>
	<43011.192.168.102.6.1216308280.squirrel@intranet>
	<487F6B2E.40101@openvz.org> <20080717173254.GA20948@tv-sign.ru>
Date: Thu, 17 Jul 2008 10:50:56 -0700
In-Reply-To: <20080717173254.GA20948@tv-sign.ru> (Oleg Nesterov's message of
	"Thu, 17 Jul 2008 21:32:54 +0400")
Message-ID: <m1mykgv1q7.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@tv-sign.ru>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4380]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/2] signals: kill(-1) should only signal processes in the same namespace
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> kill_something_info() can't walk threads, think about the realtime signals.

walking threads is fine delivering signals to non thread group leaders is
a problem.

> Anyway, I think we should change kill_something_info(-1) to use rcu_read_lock()
> instead of tasklist.

Being dense I think the locking implications of a correct implementation are more
then we are ready to deal with to fix this bug.  Although I remember discussing
it and seeing something reasonable.

Eric


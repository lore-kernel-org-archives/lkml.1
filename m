Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYHYNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYHYNYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYHYNYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:24:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51877 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYHYNYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:24:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
In-Reply-To: <20080825091508.GC9114@elte.hu> (Ingo Molnar's message of "Mon,
	25 Aug 2008 11:15:08 +0200")
References: <1219655506-27418-1-git-send-email-avi@qumranet.com>
	<20080825091508.GC9114@elte.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Mon, 25 Aug 2008 06:14:35 -0700
Message-ID: <m1vdxpnsn8.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3544]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on Intel hosts
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Avi Kivity <avi@qumranet.com> wrote:
>
>> Enabling Intel VT has the curious side effect whereby the INIT signal 
>> is blocked.  Rather than comment on the wisdom of this side effect, 
>> this patch adds an emergency restart reboot notifier, and modifies the 
>> kvm reboot notifier to disable VT on emergency reboot.

Please no notifiers in emergency_restart.

First emergency_restart is not supposed to work reliably it is a best effort tickle
the hardware thing.

Second and more importantly whenever someone adds a notifier instead of a proper hook
to one a code path like this it seems like avoiding building a proper interface so
and I believe keeps us from getting all of the logic and the heuristics right.

Why not just add a disable intel_vt if it is enabled call?

Eric

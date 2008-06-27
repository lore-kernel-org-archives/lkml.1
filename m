Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYF0SEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYF0SEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761463AbYF0SB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:01:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41239 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761697AbYF0SBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:01:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bernhard Walle <bwalle@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com> <20080627134212.GC5801@redhat.com>
	<20080627160656.06f71661@halley.suse.de>
	<20080627141910.GD5801@redhat.com>
	<20080627162223.2df5a8b9@halley.suse.de>
Date: Fri, 27 Jun 2008 11:00:44 -0700
In-Reply-To: <20080627162223.2df5a8b9@halley.suse.de> (Bernhard Walle's
	message of "Fri, 27 Jun 2008 16:22:23 +0200")
Message-ID: <m1zlp6vjub.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernhard Walle <bwalle@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0016]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bernhard Walle <bwalle@suse.de> writes:

> Ah, that's true. Only on x86, right? (That would be an alternative for
> ia64, too ...)
>
> But in general policy should go in userspace (if possible), so I agree
> with you that kexec-tools can handle that.

At a quick skim the patch looks good.  I thought I had initially implemented
the code to work this way but apparently in all of the churn that aspect of it
got lost.

Let's start with trying to allocate the memory as low as possible for
a crash kernel (I think you are already doing that).

If we need something more we can add another meta character to specify a limit.
/sbin/kexec should balk at loading if the reserved region is too high.

Ramdisks in particular are a problem because they need to be in low mem.

Eric

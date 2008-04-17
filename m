Return-Path: <linux-kernel-owner+w=401wt.eu-S935809AbYDQKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935809AbYDQKEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964867AbYDQJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:44:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48613 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbYDQJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:44:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>
References: <20080416164232.GB22748@sergelap.austin.ibm.com>
Date: Thu, 17 Apr 2008 02:44:05 -0700
In-Reply-To: <20080416164232.GB22748@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Wed, 16 Apr 2008 11:42:32 -0500")
Message-ID: <m13apkvmsa.fsf@frodo.ebiederm.org>
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
Subject: Re: [PATCH 1/3] ipc: sysvsem: implement sys_unshare(CLONE_SYSVSEM)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> (patches 1 and 2 were originally by Manfred Spraul)
>
> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
> cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
> undo lists.
>
> Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)
>
> The original reason to not support it was the potential (inevitable?)
> confusion due to the fact that sys_unshare(CLONE_SYSVSEM) has the
> inverse meaning of clone(CLONE_SYSVSEM).
>
> Our two most reasonable options then appear to be (1) fully support
> CLONE_SYSVSEM, or (2) continue to refuse explicit CLONE_SYSVSEM,
> but always do it anyway on unshare(CLONE_SYSVSEM).  This patch does
> (1).
>
> Changelog:
> 	Apr 16: SEH: switch to Manfred's alternative patch which
> 		removes the unshare_semundo() function which
> 		always refused CLONE_SYSVSEM.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

These patches look like the fix the core issue.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric

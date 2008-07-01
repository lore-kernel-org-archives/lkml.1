Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbYGASvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbYGASvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGASvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:51:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39955 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYGASvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:51:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>
	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
	<485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
Date: Tue, 01 Jul 2008 11:41:50 -0700
In-Reply-To: <486A61A7.1000902@zytor.com> (H. Peter Anvin's message of "Tue,
	01 Jul 2008 09:56:07 -0700")
Message-ID: <m1prpxh2fl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>>
>>> The zero-based PDA mechanism requires the introduction of a new ELF segment
>>> based at vaddr 0 which is sufficiently unusual that it wouldn't surprise me
> if
>>> its triggering some toolchain bug.
>>
>> Agreed.  Given the previous description my hunch is that the bug is occurring
>> during objcopy.  If vmlinux is good and the compressed kernel is bad.
>>
>
> Actually, it's not all that unusual... it's pretty common in various restricted
> environments.  That being said, it's probably uncommon for *64-bit* code.

It is a sensible thing to expect to work.  By unusual I mean it isn't triggered
by normal userspace code.  In general I find that ld features if they aren't used
in userspace and they aren't used in the kernel don't work reliably across versions.

Eric

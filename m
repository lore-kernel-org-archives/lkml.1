Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYGNJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYGNJwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbYGNJwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:52:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41576 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbYGNJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:52:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bernhard Walle <bwalle@suse.de>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Vivek Goyal" <vgoyal@redhat.com>,
       kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com>
	<86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
	<20080714112404.36783df5@halley.suse.de>
Date: Mon, 14 Jul 2008 02:44:37 -0700
In-Reply-To: <20080714112404.36783df5@halley.suse.de> (Bernhard Walle's
	message of "Mon, 14 Jul 2008 11:24:04 +0200")
Message-ID: <m1od50ztoa.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernhard Walle <bwalle@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4694]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bwalle@suse.de> writes:

> * Yinghai Lu [2008-07-14 00:11]:
>>
>> should use min_t(u64, 1ULL<<32, max_low_pfn<<PAGE_SHIFT) replace ULONG_MAX
>
> Shouldn't we use  min_t(u64, ULLONG_MAX, max_low_pfn<<PAGE_SHIFT), i.e.
> should we really limit the crashkernel to a 32 bit address on a 64 bit
> system?

We should use the lowest physical address that meets our size and
alignment constraints.  However there is no reason to make this be <
4G or even < 1G.  The worst case is that we reserve an area the kdump
kernel can't run out of.  However /sbin/kexec should check for that as
the kexec on panic code is not necessarily a linux kernel.

Eric

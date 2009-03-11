Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZCKTUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZCKTUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZCKTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:20:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44692 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZCKTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:20:19 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49B7EDF4.7060904@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 11 Mar 2009 12:20:10 -0700
In-Reply-To: <49B7EDF4.7060904@goop.org> (Jeremy Fitzhardinge's message of "Wed\, 11 Mar 2009 09\:59\:32 -0700")
Message-ID: <m1mybrzx1x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jeremy@goop.org, linux-kernel@vger.kernel.org, yinghai@kernel.org, x86@kernel.org, mingo@elte.hu, hpa@zytor.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
Subject: Re: [GIT PULL] x86: add brk allocator for very early allocations
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Aggregate patch below.
>
> The following changes since commit 11f5585820ae805c48f41c09bc260d0e51744792:
>  Ingo Molnar (1):
>        Merge branch 'tracing/ftrace'
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/x86/brk
>
> Jeremy Fitzhardinge (4):
>      x86: make section delimiter symbols part of their section
>      x86: add brk allocation for very, very early allocations
>      x86-32: use brk segment for allocating initial kernel pagetable
>      x86: use brk allocation for DMI

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

extend_brk is the wrong way to go.  We already have a better mechanism.
find_e820_early paired with reserve_early.

Allocating the early page tables are a very special case.   There is
a case for cleaning up that mechanism and making more comprehensible.
We should not be generalizing it, and making the kernel more fragile.

Overall I think there is a lot of good work in the patch, but taken
as a whole it seems to be moving us in the wrong direction.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYGJVc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYGJVc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYGJVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:32:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52250 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYGJVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:32:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>
	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>
	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>
	<48763732.7020805@sgi.com> <487641D6.5060206@goop.org>
	<487649B2.3000405@sgi.com> <48764E8A.5010400@zytor.com>
	<4876766F.4030605@linux-foundation.org> <48767804.8080007@zytor.com>
	<48767A28.7070900@linux-foundation.org>
Date: Thu, 10 Jul 2008 14:26:17 -0700
In-Reply-To: <48767A28.7070900@linux-foundation.org> (Christoph Lameter's
	message of "Thu, 10 Jul 2008 16:07:52 -0500")
Message-ID: <m1hcaxo2h2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0956]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> H. Peter Anvin wrote:
>
>> And how much is that, especially on *small* systems?
>
> i386?
>
> i386 uses 4K mappings. There are just a few cpus supported, there is scarcity of
> ZONE_NORMAL memory so the per cpu areas really cannot get that big. See the
> cpu_alloc patchsets for i386.

i386 is fundamentally resource constrained.  However x86_32 should support a
strict superset of the machines the x86_64 kernel supports.

Because it is resource constrained in the lowmem zone you should not
be able to bring up all of the cpus on a huge cpu box.   But you should still
be able to boot and run the kernel.  So for percpu data we have effectively
same size constraints.

Eric

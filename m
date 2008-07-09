Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYGIWMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYGIWMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYGIWMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:12:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38586 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYGIWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:11:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>
	<487529AE.3060505@zytor.com>
Date: Wed, 09 Jul 2008 15:10:40 -0700
In-Reply-To: <487529AE.3060505@zytor.com> (H. Peter Anvin's message of "Wed,
	09 Jul 2008 17:12:14 -0400")
Message-ID: <m1r6a2r9nj.fsf@frodo.ebiederm.org>
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
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4848]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> 1. it means pda references are invalid if their offsets are ever more than
>>> CONFIG_PHYSICAL_BASE (which I do not think is likely, but still...)
>>
>> Why?
>>
>> As an aside, could we solve the problems by making CONFIG_PHYSICAL_BASE 0 -
>> putting the percpu variables as the first thing in the kernel - and relocating
>> on load?  That would avoid having to make a special PT_LOAD segment at 0.  Hm,
>> would that result in the pda and the boot params getting mushed together?
>>
>
> CONFIG_PHYSICAL_START rather.  And no, it can't be zero!  Realistically we
> should make it 16 MB by default (currently 2 MB), to keep the DMA zone clear.

Also on x86_64 CONFIG_PHYSICAL_START is irrelevant as the kernel text segment
is liked at a fixed address -2G and the option only determines the virtual
to physical address mapping.

That said the idea may not be too far off.

Potentially we could put the percpu area at our fixed -2G address and then
we have a constant (instead of an address) we could subtract from this address.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYGKAwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYGKAwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYGKAwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:52:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39513 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYGKAwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:52:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>
	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>
	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>
	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>
	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>
	<487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org>
	<487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org>
	<48764C7C.5010309@goop.org> <48767692.4080504@linux-foundation.org>
	<487677F0.4000404@goop.org> <4876799B.7010204@linux-foundation.org>
	<48767F4F.1010209@zytor.com> <4876A56C.3050707@sgi.com>
Date: Thu, 10 Jul 2008 17:42:52 -0700
In-Reply-To: <4876A56C.3050707@sgi.com> (Mike Travis's message of "Thu, 10 Jul
	2008 17:12:28 -0700")
Message-ID: <m1ej61fdyr.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0029]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Btw, the "zero_based_only" patch (w/o the pda folded into the percpu
> area) gets to the point shown below.  Dropping NR_CPUS from 4096 to 256
> clears up the error.  So except for the "stack overflow" message I got
> yesterday, the result is the same.  As soon as I get a chance, I'll try
> it out with gcc-4.2.0 to see if it changed the boot up problem.

Thanks that seems to confirm the suspicion that it the zero based percpu
segment that is causing problems.

In this case it appears that the notifier block for one of the cpu notifiers
got stomped, or never got initialized.

Eric

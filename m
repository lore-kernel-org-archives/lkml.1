Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYGJUWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYGJUWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYGJUWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:22:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44927 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYGJUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:22:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>
	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>
	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>
	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>
	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>
	<m1prpl4pmh.fsf@frodo.ebiederm.org> <48764C21.4020601@zytor.com>
	<m1fxqhzhcu.fsf@frodo.ebiederm.org> <4876608B.10408@sgi.com>
Date: Thu, 10 Jul 2008 13:17:54 -0700
In-Reply-To: <4876608B.10408@sgi.com> (Mike Travis's message of "Thu, 10 Jul
	2008 12:18:35 -0700")
Message-ID: <m1zloptrwt.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0051]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:


> The biggest growth came from moving all the xxx[NR_CPUS] arrays into
> the per cpu area.  So you free up a huge amount of unused memory when
> the NR_CPUS count starts getting into the ozone layer.  4k now, 16k
> real soon now, ??? future?

Hmm.  Do you know how big a role kernel_stat plays.

It is a per cpu structure that is sized via NR_IRQS.  NR_IRQS is by NR_CPUS.
So ultimately the amount of memory take up is NR_CPUS*NR_CPUS*32 or so.

I have a patch I wrote long ago, that addresses that specific nasty configuration
by moving the per cpu irq counters into pointer available from struct irq_desc.

The next step which I did not get to (but is interesting from a scaling perspective)
was to start dynamically allocating the irq structures.

Eric


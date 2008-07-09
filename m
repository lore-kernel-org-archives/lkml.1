Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYGIXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYGIXmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYGIXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:42:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51284 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYGIXl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:41:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>
Date: Wed, 09 Jul 2008 16:36:24 -0700
In-Reply-To: <48753C99.5050408@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 09 Jul 2008 15:32:57 -0700")
Message-ID: <m1ej62iq9z.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0581]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>> Which means that my idea of using the technique we use on x86_32 will not
> work.
>
> No, the compiler memory model we use guarantees that everything will be within
> 2G of each other.  The linker will spew loudly if that's not the case.

The per cpu area is at least theoretically dynamically allocated.  And we
really want to put it in cpu local memory.    Which means on any reasonable
NUMA machine the per cpu areas should be all over the box.

So there is no guarantee that with an arbitrary 64bit address in %gs of anything.

Grr.  Except you are correct.  We have to guarantee that the offsets we have
chosen at compile time still work.  And we know all of the compile time offsets
will be in the -2G range.  So they are all 32bit numbers.  Negative 32bit
numbers to be sure.  That trivially leaves us with everything working except
the nasty hard coded decimal 40.

Eric

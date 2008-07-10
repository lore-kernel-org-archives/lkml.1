Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYGJUc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYGJUc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGJUcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:32:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33972 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYGJUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:32:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>
	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>
	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>
	<48763732.7020805@sgi.com> <m1lk091soo.fsf@frodo.ebiederm.org>
	<48765B03.6020905@goop.org> <m1ej61y2da.fsf@frodo.ebiederm.org>
	<48766967.7040008@goop.org>
Date: Thu, 10 Jul 2008 13:22:52 -0700
In-Reply-To: <48766967.7040008@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 10 Jul 2008 12:56:23 -0700")
Message-ID: <m1fxqhtroj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4514]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> No, that sounds like a bad idea.  For one, how would you enforce it?  How would
> you check for it?  It's one of those things that would mostly work and then fail
> very rarely.

Well the easiest way would be to avoid the letting people take the address of
per cpu memory, and just provide macros to read/write it.  We are 90% of the
way there already so it isn't a big jump.

> Secondly, I depend on it.  I register a percpu structure with Xen to share
> per-vcpu specific information (interrupt mask, time info, runstate stats, etc).

Well even virtual allocation is likely to break the Xen sharing case as you
would at least need to compute the physical address and pass it to Xen.

Eric

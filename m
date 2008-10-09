Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbYJIMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbYJIMsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYJIMsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:48:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYJIMsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:48:06 -0400
Date: Thu, 9 Oct 2008 14:46:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       MinChan Kim <minchan.kim@gmail.com>, arnd@arndb.de, jeremy@goop.org
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
Message-ID: <20081009124658.GE2952@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oren Laadan <orenl@cs.columbia.edu> wrote:

> These patches implement basic checkpoint-restart [CR]. This version 
> (v6) supports basic tasks with simple private memory, and open files 
> (regular files and directories only). Changes mainly cleanups. See 
> original announcements below.

i'm wondering about the following productization aspect: it would be 
very useful to applications and users if they knew whether it is safe to 
checkpoint a given app. I.e. whether that app has any state that cannot 
be stored/restored yet.

Once we can do that, if the kernel can reliably tell whether it can 
safely checkpoint an application, we could start adding a kernel driven 
self-test of sorts: a self-propelled kernel feature that would 
transparently try to checkpoint various applications as it goes, and 
restore them immediately.

When such a test-kernel is booted then all that should be visible is an 
occasional slowdown due to the random save/restore cycles of various 
processes - but no actual application breakage should ever occur, and 
the kernel must not crash either. This would work a bit like 
CONFIG_RCUTORTURE: a constant test that should be transparent in terms 
of functionality.

Also, the ability to tell whether a process can be safely checkpointed 
would allow apps to rely on it - they cannot accidentally use some 
kernel feature that is not saved/restored and then lose state across a 
CR cycle.

Plus, as a bonus, the inability to CR a given application would sure 
spur the development of proper checkpointing of that given kernel state. 
We could print some once-per-boot debug warning about exactly what bit 
cannot be checkpointed yet. This would create proper pressure from 
actual users of CR.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S935867AbXGXLwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867AbXGXLwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbXGXLwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:52:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450AbXGXLwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:52:06 -0400
Date: Tue, 24 Jul 2007 13:51:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <20070724115148.GA12799@elte.hu>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com> <46A5E39D.7030009@shadowen.org> <20070724114713.GA9817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724114713.GA9817@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> what the hell are you thinking? Not every trivial line of code needs 
> to be commented. Comments are needed for the _nontrivial_ lines of 
> code, and there's no way a tool can decide that. [...]

and i thought you understood this point, as earlier versions of 
checkpatch.pl were carefully filtering out _known nontrivial_ code, such 
as the barrier APIs (smp_rmb(), etc.) where we know that they are 
nontrivial in _100%_ of the cases.

trying to warn about code that 'might' be unclean is a catastrophy. This 
tool should only make noise if it is _really_ sure that there's 
something wrong going on. If the tool cannot make an intelligent 
decision about it then it should be silent!

Btw., there's an easy solution for v0.08's many breakages: turn off the 
WARNING output by default and rename it to 'INFO' or something other 
non-alarming.

	Ingo

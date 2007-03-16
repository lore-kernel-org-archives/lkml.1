Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXCPK3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXCPK3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXCPK3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:29:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbXCPK3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:29:47 -0400
Date: Fri, 16 Mar 2007 11:29:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64 - Take 3
Message-ID: <20070316102933.GB4185@elte.hu>
References: <20070315051337.488091591@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315051337.488091591@goodmis.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Once again here's an attempt to put the shared files of x86_64 and 
> i386 into a separate directory.

what do you think about the idea i suggested: to do an x32_/x64_ prefix 
(or _32/_64 postfix), in a brute-force way, _right away_. I.e. do not 
have any overlap of having both arch/i386/ and arch/x86_64/ and 
arch/x86/ - move everything to arch/x86/ right now.

in the initial step we dont even have to attempt to share anything - we 
just want to make sure everything still works fine. Just create a 
'unified' layout with the prefix/postfix solution, and make sure that 
the build architecture can compile existing .configs just fine, which 
results in a functionally identical vmlinux that would be built if these 
files were still in arch/i386/ (and arch/x86_64/).

i dont think we want to have a too long 'overlap' period. Lets just 
unify them, that would be the only large-scale intrusive move.

>From that point on, the unification decisions would be largely per-file: 
"do we want to unify process_32.c and process_64.c into the same file?".

	Ingo

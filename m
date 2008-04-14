Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbYDNIfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbYDNIfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbYDNIfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:35:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551AbYDNIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:35:10 -0400
Date: Mon, 14 Apr 2008 10:34:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080414083440.GD19865@elte.hu>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com> <20080411152648.GK9785@ZenIV.linux.org.uk> <20080414081220.GA19865@elte.hu> <20080414082220.GZ9785@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414082220.GZ9785@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Apr 14, 2008 at 10:12:20AM +0200, Ingo Molnar wrote:
> 
> > well, gcc does not "recover", we _gave_ it the format string as a 
> > constant, and do so in 99.9% of the cases. It is a totally 
> > well-specified thing.
> 
> It is an undefined behaviour according to any variant of C standard. 
> Sorry, printf() is not magic and it does _not_ have special calling 
> conventions.

... but reality called in and gcc added printf format checks as a gcc 
extension and even modifies the code to make it safe when the user gets 
it "wrong".

why? Because vararg is a dangerous concept as specified and strong but 
meaningful type checking should be enforced across such places. And our 
goal is to build better software and avoid bugs that can be avoided, not 
to follow standards where they are _stupid_.

> What is not right is the lack of ability to define new conversions.  
> If we could do that, we would kill the absolute majority of casts - 
> and remain within normal C limits...

sure. I dont actually care that much how it's solved - via extending the 
concept of varargs or via working it around where it hurts most. What 
matters is that the current situation is suboptimal. The present 
"solution" uglifies the code and more ugly code is always more 
dangerous.

But it's even worse: bogus warnings also reduce the psychological 
threshold to adding stupid casts - if you have to add casts in a printk 
that looks senseless then why not circumvent _other_ warnings that look 
senseless?

Excessive false positives are actively harmful to software quality 
because they teach people to ignore warnings.

	Ingo

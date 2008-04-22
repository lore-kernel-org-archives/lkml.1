Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYDVNHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYDVNHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbYDVNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:07:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34439 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbYDVNHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:07:30 -0400
Date: Tue, 22 Apr 2008 15:07:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: fix optional arch functions and probe_kernel_*
Message-ID: <20080422130720.GA7311@elte.hu>
References: <200804181742.m3IHgsoG012669@hera.kernel.org> <20080418154800.82f814e0.akpm@linux-foundation.org> <20080421140058.GO9554@elte.hu> <480C9F0E.30500@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C9F0E.30500@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> >> Still.  Do we need the set_fs() in there?  
> >> __copy_from_user_inatomic() is a "__" uaccess function and hence 
> >> shouldn't be running access_ok()?
> >
> > yeah, i guess that's true. Jason?
> 
> In so far as the testing showed, it worked ok on the X86 arch with and 
> without the set_fs(), but on ARM it is absolutely required.  This 
> means we have to decide to make arch specific or leave generic as it 
> stands right now.

yeah, i guess so - it's no big issue as this isnt performance critical 
in any way. Do you know which exact codepath/mechanism in ARM relies on 
the set_fs() being there?

	Ingo

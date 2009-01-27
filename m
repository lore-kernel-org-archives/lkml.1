Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZA0NGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZA0NGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZA0NGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:06:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZA0NGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:06:24 -0500
Date: Tue, 27 Jan 2009 14:06:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Takashi Iwai <tiwai@suse.de>, Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [2.6.29-rc2-git2] compilation warnings
Message-ID: <20090127130608.GD23121@elte.hu>
References: <497EB491.6080904@numericable.fr> <s5hbpttcigu.wl%tiwai@suse.de> <20090127094628.670eca16@hyperion.delvare> <s5h1vupcctf.wl%tiwai@suse.de> <20090127134854.1a9992fd@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127134854.1a9992fd@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jean Delvare <khali@linux-fr.org> wrote:

> Hi Takashi,
> 
> On Tue, 27 Jan 2009 10:34:20 +0100, Takashi Iwai wrote:
> > At Tue, 27 Jan 2009 09:46:28 +0100,
> > > On Tue, 27 Jan 2009 08:32:17 +0100, Takashi Iwai wrote:
> > > > A bogus warning.  Ignore this.
> > > 
> > > No matter how bogus it is, it should be fixed. Otherwise this is
> > > wasting the time of users and developers over and over again.
> > 
> > Well, it's a bug of gcc appearing only in a certain version, so most
> > people won't see it.
> > 
> > Of course, we can put uninitialized_var().  But, I don't basically
> > like adding it unconditionally... 
> 
> I didn't know about uninitialized_var(), thanks for the hint.
> 
> My experience with these warnings is that, in many cases, it is possible 
> to write the code differently so that it is clear to the compiler that 
> the variable is never used uninitialized. In some cases, doing so also 
> makes the code easier to read for humans and less likely to break in the 
> future.
> 
> Of course, in some cases the problem is simply that the compiler is too 
> stupid to understand even simple things, but in other cases these 
> warnings might be a good opportunity to rewrite the code in a way that 
> is easier to understand.

And even in the cases where the compiler is stupid, leaving a warning 
around:

   1) Does not get compiler bugs fixed any faster [only true competition 
      between compilers gets compiler bugs fixed any faster]

   2) Has ongoing and irreversible maintenance costs for _all of us in the 
      kernel_

   3) for every bogus compiler warning there's a dozen warnings where the 
      compiler told us that _we_ were doing something stupid. All things 
      considered the false positive ratio is still a fair deal.

So leaving them around is a bit like making a political point by burning 
yourself in front of the cameras - leaves the political opponent largely 
unimpressed and unscathed while being self-destructive in 99% of the 
cases.

gcc_is_utterly_stupid(var) type of annotations (that initialize to zero 
instead of the current 'turn off the warning' dangerous construct) would 
be far better. Albeit even that would in all likelyhood be a rather 
pointless (but admittedly satisfying) gesture.

	Ingo

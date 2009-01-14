Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZANUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZANUMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZANUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:12:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41738 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZANUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:12:14 -0500
Date: Wed, 14 Jan 2009 21:11:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
Message-ID: <20090114201152.GA31581@elte.hu>
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com> <20090114111949.GO2913@elte.hu> <496E4211.6040503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E4211.6040503@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

>     mkdir linux-2.6-cpus4096-for-ingo
>     cd linux-2.6-cpus4096-for-ingo
>     git-init-db
>     git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>     git-remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
>     git-remote add my-cpus4096 git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git
>     git-remote add push-cpus4096 ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git
>     git-config --add remote.push-cpus4096.skipDefaultUpdate true
>     git-remote update

hm, why do you do all this? You should just create a -git based repo on 
kernel.org:

  cd /pub/scm/linux/kernel/git/travis/
  rm -rf linux-2.6-cpus4096-for-ingo
  git-clone --bare --shared ../torvalds/linux-2.6.git linux-2.6-cpus4096-for-ingo

that's all - you dont ever have to touch the master.kernel.org bits on 
that box anymore. Then you can clone it (via ssh) to your local box:

  git clone ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo

that's it - you are all set!

Now you can go into your repo, and do a few convenience things like:

     git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
     git-remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

     git remote update

But these dont ever go to your master.kernel.org tree. Your local 'master' 
branch is what you will push out most of the time.

To prepare a tree for me, if you want to base it on the latest 
tip/cpus4096, you do this:

     git checkout master
     git reset --hard tip/cpus4096

that's all. You can then (force-)push this out to your kernel.org repo 
via:

     git push -f origin master

and you can manipulate your master branch and push it out to your 
master.kernel.org repo whenever you want to.

If you want a separate 'release' branch, you can do it too:

   git checkout master

   [ prepare your master branch with the bits. ]

   git checkout -b for-ingo
   git push origin for-ingo

   [ git checkout master ]

That's it. If the for-ingo branch already exists and you know that it 
contains no bits that i might pull in parallel with you updating it, you 
can force-push it as well:

   git checkout for-ingo
   git reset --hard master          # set it to your release bits
   git push -f origin for-ingo

that's it really.

	Ingo

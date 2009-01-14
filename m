Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZANV0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZANV0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZANV0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:26:33 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43893 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753895AbZANV0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:26:32 -0500
Message-ID: <496E587E.6010503@sgi.com>
Date: Wed, 14 Jan 2009 13:26:22 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com> <20090114111949.GO2913@elte.hu> <496E4211.6040503@sgi.com> <20090114201152.GA31581@elte.hu>
In-Reply-To: <20090114201152.GA31581@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very cool, thanks!!

The one thing I always get hung up on is what args to use with the git
rebase -i command.  Say I want to edit 4a046d1 (which I do ;-), I see
it in my repo with git-log (3rd one down):

commit e46d517...
Merge: a4a0acf... 4a046d1...
Author: Ingo Molnar <mingo@elte.hu>

    Merge branch 'master' of ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo into cpus4096

commit a4a0acf...
Author: Suresh Siddha <suresh.b.siddha@intel.com>

    x86: fix broken flush_tlb_others_ipi()

commit 4a046d1...
Author: Yinghai Lu <yinghai@kernel.org>

    x86: arch_probe_nr_irqs

commit e65e49d...
Author: Mike Travis <travis@sgi.com>

    irq: update all arches for new irq_desc


So, upstream is tip/cpus4096 yes?  But then:

: git-rebase -i tip/cpus4096
Nothing to do

Attempting other args proved equally fruitless.

Thanks,
Mike

Ingo Molnar wrote:
... You should just create a -git based repo on 
> kernel.org:
> 
>   cd /pub/scm/linux/kernel/git/travis/
>   rm -rf linux-2.6-cpus4096-for-ingo
>   git-clone --bare --shared ../torvalds/linux-2.6.git linux-2.6-cpus4096-for-ingo
> 
> that's all - you dont ever have to touch the master.kernel.org bits on 
> that box anymore. Then you can clone it (via ssh) to your local box:
> 
>   git clone ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo
> 
> that's it - you are all set!
> 
> Now you can go into your repo, and do a few convenience things like:
> 
>      git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>      git-remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> 
>      git remote update
> 
> But these dont ever go to your master.kernel.org tree. Your local 'master' 
> branch is what you will push out most of the time.
> 
> To prepare a tree for me, if you want to base it on the latest 
> tip/cpus4096, you do this:
> 
>      git checkout master
>      git reset --hard tip/cpus4096
> 
> that's all. You can then (force-)push this out to your kernel.org repo 
> via:
> 
>      git push -f origin master
> 
> and you can manipulate your master branch and push it out to your 
> master.kernel.org repo whenever you want to.
> 
> If you want a separate 'release' branch, you can do it too:
> 
>    git checkout master
> 
>    [ prepare your master branch with the bits. ]
> 
>    git checkout -b for-ingo
>    git push origin for-ingo
> 
>    [ git checkout master ]
> 
> That's it. If the for-ingo branch already exists and you know that it 
> contains no bits that i might pull in parallel with you updating it, you 
> can force-push it as well:
> 
>    git checkout for-ingo
>    git reset --hard master          # set it to your release bits
>    git push -f origin for-ingo
> 
> that's it really.
> 
> 	Ingo


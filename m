Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYFXSI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYFXSI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYFXSIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:08:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYFXSIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:08:20 -0400
Date: Tue, 24 Jun 2008 20:08:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: merge conflicts with tip/master
Message-ID: <20080624180808.GA14994@elte.hu>
References: <1214327937.27577.6.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214327937.27577.6.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

> Hi Ingo,
> 
> While working with tip/master...after following the steps in the readme
> @ http://people.redhat.com/mingo/tip.git/readme.txt
> 
> I usually do any changes and manage them using "quilt". Once the 
> changes are pushed upstream, i do a "quilt pop" and generally try a 
> "git pull" to check for any new changes, along with the change that 
> was just pushed.
> 
> This method works fine for me with Linus's tree. But with tip/master i 
> usually get "merge conflicts"
> 
> Am i doing something wrong over here...am i supposed to not use git 
> pull for updating the local tip/master copy ?

i dont think this is due to Quilt interaction, but possibly due to the 
fact that you should update the remote branches via "git remote update".

another possibility is that Quilt touches a file and can change its 
timestamp - so Git thinks it's modified. You'll get something like:

  $  git-checkout tip-latest
  M       kernel/sched.c
  Already on branch "tip-latest"

the "M" shows that the file has been modified.

If you are absolutely sure you have a non-modified repository (sans 
timestamps), you can force a checkout via:

  git-checkout -f tip-latest

the '-f' will force a checkout and any local changes will be 
overwritten.

finally, if tip/master has been updated, you can 'jump' to it without 
doing a pull, via:

  git-checkout tip-latest
  git-reset --hard tip/master

NOTE: this too is destructive to any local Git state and should be used 
with care.

	Ingo

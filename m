Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYADNIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYADNIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYADNHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:07:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407AbYADNHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:07:51 -0500
Date: Fri, 4 Jan 2008 14:07:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by
	checkpatch.pl
Message-ID: <20080104130702.GC20981@elte.hu>
References: <20080104003253.7a7309d8@paolo-desktop> <20080104083442.GD22803@elte.hu> <4d8e3fd30801040318q2e3be951rbf517f7d6022ae04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801040318q2e3be951rbf517f7d6022ae04@mail.gmail.com>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> paolo@paolo-desktop:~/linux-2.6/kernel$ ../scripts/checkpatch.pl
> --file profile.c

that's OK.

> What I still don't understand are the following options:
>  --no-tree    => run without a kernel tree
>  --root       => path to the kernel tree root
> 
> Should I specify the path to the kernel tree root? If so, why?

it figures it out itself - if it cannot it will tell you.

> That said, the errors reported by checkpatch.pl are now:
> paolo@paolo-desktop:~/linux-2.6/kernel$ ../scripts/checkpatch.pl
> --terse --file profile.c |grep ERROR
> profile.c:128: ERROR: "foo * bar" should be "foo *bar"
> I just forgot to fix it, very trivial. Will do in a minute.
> 
> profile.c:460: ERROR: do not use assignment in if condition (+  if
> (!(entry = create_proc_entry("XXXXXXXXXXXXX", 0600, root_irq_dir))))
> profile.c:594: ERROR: do not use assignment in if condition (+  if
> (!(entry = create_proc_entry("XXXXXXX", S_IWUSR | S_IRUGO, NULL))))
> Here I need an hint ( or an example) about how to fix these two errors :-)

transform:

  if (!(x = y))

to:

  x = y
  if (!x)

i.e. take the implicit assignment out of the condition. (it's easy to 
mistake it for '==' while reviewing the code and forgetting about the 
assignment's side-effect)

	Ingo

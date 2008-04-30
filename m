Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbYD3SbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbYD3SbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYD3SbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:31:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbYD3SbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:31:04 -0400
Date: Wed, 30 Apr 2008 20:30:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: den@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [patch, -git] isdn: hysdn_procconf.c build fix
Message-ID: <20080430183051.GA3008@elte.hu>
References: <1207653508.7171.18.camel@iris.sw.ru> <1207653576-12640-25-git-send-email-den@openvz.org> <20080430175740.GA26612@elte.hu> <20080430111052.9c0c8974.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430111052.9c0c8974.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 30 Apr 2008 19:57:40 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Ob'grumpy: this file was not even build-tested by any of the parties 
> > who turned it into upstream commit ac41cfd19b ("isdn: use non-racy 
> > method for proc entries creation").
> 
> That's because this stupidity:
> 
> config HYSDN
>         tristate "Hypercope HYSDN cards (Champ, Ergo, Metro) support (module only)"
>         depends on m && PROC_FS && PCI && BROKEN_ON_SMP
> 
> breaks allmodconfig coverage testing.

yeah. There's a trick though that we use in the x86 tree (and which i'm 
using in a script when queuing up new patches). The following command 
will punch through any Kconfig black holes:

  make drivers/isdn/hysdn/hysdn_procconf.o

(it wont always work as it needs a halfways reasonable .config, but it 
works well enough to be part of my workflow.)

note that there's tons more stuff and dependencies that plain 
allmodconfig does not catch - in this merge window alone i'm at around 
20 fixes so far.

	Ingo

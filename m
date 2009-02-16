Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZBPUCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZBPUCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZBPUC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:02:27 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47872 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZBPUC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:02:26 -0500
Date: Mon, 16 Feb 2009 21:04:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as possible
Message-ID: <20090216200415.GA16721@uranus.ravnborg.org>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150835.GA30027@oksana.dev.rtsoft.ru> <20090204212612.GN22608@elte.hu> <20090214195702.GB1241@uranus.ravnborg.org> <20090216142001.GA27869@oksana.dev.rtsoft.ru> <20090216145317.GA3616@oksana.dev.rtsoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216145317.GA3616@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> There are few arches that have "auto detection" of CROSS_COMPILE
> variable: mips, m68k, parisc, xtensa, h8300 and blackfin.
> 
> So `normal' arches don't have any chance to overwrite the flags
> because of the few offenders above. ;-)

We also have archs where we add options to gcc that may
impact for example -fno-stack-protector.
We had a bug in x86 in this area for a while.

So the only sane thing is to only add the most generic options to
KBUILD_CFLAGS before we include the arch specific part.
And we can then add the conditional options later - like
the KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
in this case.

We learned a few lessons in this area over time as your
history digging also showed.

	Sam

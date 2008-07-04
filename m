Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYGDRcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYGDRcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYGDRcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:32:33 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:44594 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYGDRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:32:32 -0400
To: rankincj@yahoo.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Linux 2.6.25.10
References: <555236.75770.qm@web52912.mail.re2.yahoo.com>
From: Nix <nix@esperi.org.uk>
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Date: Fri, 04 Jul 2008 18:32:26 +0100
In-Reply-To: <555236.75770.qm@web52912.mail.re2.yahoo.com> (Chris Rankin's message of "4 Jul 2008 00:42:42 +0100")
Message-ID: <87vdzlv9lh.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-INFN-TO-Metrics: hades 1233; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Jul 2008, Chris Rankin stated:
> I have only machines with 32 bit CPUS, none of them is hot-pluggable
> and none has an i915 graphics chip. All my local users are "trusted",
> nor am I running any multi-threaded Java applications on SMP
> systems. (I also have no idea what ICM pages are, but they sound jolly
> impressive!)

A good clue here is to look at the subdirectories that were touched.
The ICM stuff says in the commit log

    IB/mthca: Clear ICM pages before handing to FW

and touches only files under drivers/infiniband/hw/mthca.

So if you don't use the InfiniBand driver, you're almost certainly safe
(and from what I understand of InfiniBand, if you're not running a huge
corporate SAN or something you're highly unlikely to be using it).

> And what is "native_read_tscp" all about?

>From the name I would have assumed something about networking with some
strangely-named protocol, but from the file being touched,
include/asm-x86/msr.h, it's something to do with x86 model-specific
registers. One function in that header calls it: `rdtscp()'. A grep -R
for `rdtscp' under arch/x86 indicates that there is a word in
/proc/cpuinfo devoted to indicating whether your CPU has this
feature. If it doesn't, the bug doesn't affect you.

>From the other hit, rdtscp()'s one call site, it seems to be some way to
get the current CPU fast on SMP x86-64 boxes.  So perhaps you should
upgrade if you have one of those.

Generally a bit of grepping and matching on pathnames like this is
enough to comprehensively rule most changes in or out as things that
affect you, and of course if there are changes to mm code or something
like that it's generally a good idea to upgrade anyway, because you
can't very well avoid using said code.

> (Your emphasis.) Is it because otherwise you're going to sneak up and
> burn my house down?

Greg would never do a thing like that without forewarning.

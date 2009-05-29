Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbZE2Tyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbZE2Tyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbZE2Tyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:54:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41731 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761427AbZE2Tyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:54:44 -0400
Date: Fri, 29 May 2009 22:01:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, apw@canonical.com
Subject: Re: [tip:x86/mce3] x86, mce: trivial clean up for mce_amd_64.c
Message-ID: <20090529200129.GB1065@one.firstfloor.org>
References: <tip-34fa1967aa0827776e37feb5666df0327575a0f2@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-34fa1967aa0827776e37feb5666df0327575a0f2@git.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> ERROR: Macros with multiple statements should be enclosed in a do - while
> loop

That seems more like a checkpatch.pl bug -- clearly you cannot put
a do {} while loop into a declaration like here. I don't know who comes up
with these useless warnings? At least they should be made warnings,
not errors and then be ignored if they don't make any sense like this.

The change imho makes the code worse.

> +#define THRESHOLD_ATTR(_name, _mode, _show, _store)                    \
> +{                                                                      \
> +       .attr   = {.name = __stringify(_name), .mode = _mode },         \
> +       .show   = _show,                                                \
> +       .store  = _store,                                               \
> +};

> WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(),
> num_possible_cpus(), for_each_possible_cpu(), etc
> +       if (cpu >= NR_CPUS)

In this case it's not wrong either. It's a bit paranoid, but not wrong.

NR_CPUS is only wrong when used in arrays.

-Andi


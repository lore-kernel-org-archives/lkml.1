Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbZFZTX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbZFZTX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbZFZTXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:23:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759524AbZFZTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:23:14 -0400
Date: Fri, 26 Jun 2009 12:21:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ink@jurassic.park.msu.ru, tj@kernel.org, max@stro.at,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: >= 2.6.30 broken alpha smp build
Message-Id: <20090626122152.e124254b.akpm@linux-foundation.org>
In-Reply-To: <20090626115746.09314757.akpm@linux-foundation.org>
References: <20090625090842.GA17936@stro.at>
	<20090625115423.6a31b49c.akpm@linux-foundation.org>
	<4A4419AA.2040400@kernel.org>
	<20090626124705.GA25147@jurassic.park.msu.ru>
	<20090626115746.09314757.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 11:57:46 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Anyway, we need a backportable fix, so I'll put this through
> some build testing:

The allmodconfig build has more problems:

ERROR: "per_cpu__cookie_scratch" [net/ipv6/ipv6.ko] undefined!
ERROR: "per_cpu__rcu_torture_batch" [kernel/rcutorture.ko] undefined!
ERROR: "per_cpu__rcu_torture_count" [kernel/rcutorture.ko] undefined!
ERROR: "clk_enable" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_get" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_put" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_disable" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_get_rate" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "per_cpu__msg_schedule" [crypto/sha512_generic.ko] undefined!
ERROR: "per_cpu__ioc_count" [block/cfq-iosched.ko] undefined!
ERROR: "per_cpu__ioc_count" [block/as-iosched.ko] undefined!

It looks like making these DEFINE_PER_CPUs non-static will fix it up. 
What's that all about?


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYILL4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYILL4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYILL4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:56:42 -0400
Received: from nebensachen.de ([195.34.83.29]:52357 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYILL4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:56:41 -0400
X-Hashcash: 1:20:080912:bzolnier@gmail.com::SsU/cwxp64kx83yI:00000000000000000000000000000000000000000000W77
X-Hashcash: 1:20:080912:alan@lxorguk.ukuu.org.uk::TPDE3HXPB8eFzAst:00000000000000000000000000000000000002NqP
X-Hashcash: 1:20:080912:akpm@linux-foundation.org::Ab6okBg+k4kIndlL:0000000000000000000000000000000000006K8n
X-Hashcash: 1:20:080912:jeff@garzik.org::HZheUjRvdDD2weKA:002+gj
X-Hashcash: 1:20:080912:randy.dunlap@oracle.com::pQUQvDq4LG+47FZW:000000000000000000000000000000000000001zom
X-Hashcash: 1:20:080912:htejun@gmail.com::BxkZejZWKcBtDnM2:01SwX
X-Hashcash: 1:20:080912:linux-ide@vger.kernel.org::nY48pdWIgAnjmLA+:0000000000000000000000000000000000004XO8
X-Hashcash: 1:20:080912:linux-kernel@vger.kernel.org::Qs52GBsx5DORSRCa:0000000000000000000000000000000000mXQ
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>
	<200809012129.14979.bzolnier@gmail.com>
	<87ljy90zin.fsf@denkblock.local>
	<200809051933.38888.bzolnier@gmail.com>
	<87vdx1y9gv.fsf@denkblock.local>
Date: Fri, 12 Sep 2008 13:55:17 +0200
In-Reply-To: <87vdx1y9gv.fsf@denkblock.local> (Elias Oltmanns's message of
	"Fri, 12 Sep 2008 11:55:28 +0200")
Message-ID: <87ljxxy3x6.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
[...]
>> Since Tejun already raised concerns about multiplexing per-device
>> and per-port settings I'm not repeating them here.  Please just
>> remember to backport fixes from libata version to ide one.
>
> For the sake of consistency, I've always tried to make ide and libata
> behave alike (or as close to it as possible). However, the final version
> of the libata patch is very hard to mimc in ide. Therefore, I wonder
> whether we can do in ide what we'd really like to do in libata
> eventually. The patch below is a real per-device implementation of the
> unload feature. However, I'd like you to confirm the crucial assumption
> underlying this patch: a port reset is the only way a device can
> interfere with another device on the same port. In particular, I haven't
> made an effort to understand pnp and similar stuff completely, but from
> a first glance I got the impression that these things are done per-port
> rather than per-device and that nothing sinister will happen behind our
> back. In short, can you confirm the following:
>
> Condition:  device A on a port is parked (implies there is at least one
>             request on the queue of that device, i.e we hold a
>             reference to the device and thus to the port).
> Assumption: nothing will disturb the device because resets due to
>             command failure / timeouts on device B are deferred (see my
>             patch) and spurious commands like IDENTIFY (or whatever
>             actions may be related to pnp and the like) are not 
>             performed while the device is sleeping and a request is
>             waiting on the queue.

Sorry for spamming you again, but I forgot to mention one more thing: In
my hardware environment, I cannot easily test the code in do_reset1()
which is supposed to defer resets if necessary. Since we have something
very similar in libata (which I have tested), I'm quite confident that
everything will work out nicely. Still, you may want to pay special
attention to this piece of code.

Regards,

Elias

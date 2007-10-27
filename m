Return-Path: <linux-kernel-owner+w=401wt.eu-S1764559AbXJ0AFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764559AbXJ0AFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXJ0AE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:04:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50191 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbXJ0AE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:04:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: rick.jones2@hp.com, bunk@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] always export sysctl_{r,w}mem_max
References: <20071026230807.GE30533@stusta.de>
	<m1zly5wjie.fsf@ebiederm.dsl.xmission.com> <472278E3.4000909@hp.com>
	<20071026.163958.171785530.davem@davemloft.net>
Date: Fri, 26 Oct 2007 18:04:22 -0600
In-Reply-To: <20071026.163958.171785530.davem@davemloft.net> (David Miller's
	message of "Fri, 26 Oct 2007 16:39:58 -0700 (PDT)")
Message-ID: <m1d4v1whh5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Rick Jones <rick.jones2@hp.com>
> Date: Fri, 26 Oct 2007 16:31:47 -0700
>
>> Eric W. Biederman wrote:
>> > Adrian Bunk <bunk@kernel.org> writes:
>> > 
>> > 
>> >>This patch fixes the following build error with CONFIG_SYSCTL=n:
>> >>
>> >><--  snip  -->
>> >>
>> >>...
>> >>ERROR: "sysctl_rmem_max" [fs/dlm/dlm.ko] undefined!
>> >>ERROR: "sysctl_wmem_max" [drivers/net/rrunner.ko] undefined!
>> >>ERROR: "sysctl_rmem_max" [drivers/net/rrunner.ko] undefined!
>> >>make[2]: *** [__modpost] Error 1
>> > 
>> > 
>> > I was going to ask if allowing drivers to increase rmem_max
>> > is something that we want to do.  Apparently the road runner
>> > driver has been doing this since the 2.6.12-rc1 when the
>> > git repository starts so this probably isn't a latent bug.
>> 
>> Although it does rather sound like a driver writer yanking the rope from the 
>> hand's of the sysadmin and hanging him with it rather than letting the
> sysadmin
>> do it himself.  I've seen other drivers' README's suggesting larger mem's but
>> not their sources doing it.
>
> I really don't think what the roadrunner driver is doing is
> correct at all.
>
> I also think what DLM is doing is wrong too.
>
> If DLM really wants minimum, it can use SO_SNDBUFFORCE and
> SO_RCVBUFFORCE socket options and use whatever limits it
> likes.
>
> But even this is questionable.
>
> I'll put in Adrian's patch to fix the build as a first
> priority, but in the long term this cruft has gotta go.

As it stands this is a very old build bug.  I believe those
symbols have always been exported inside of #ifdef CONFIG_SYSCTL.

So if this is really something we want to stop doing we should
be able to take a few extra moments remove the code from the
two problem drivers, and remove the exports.

It didn't look like any of the other users could possibly be
modular.

Eric





Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXFBDtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXFBDtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 23:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbXFBDtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 23:49:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45358 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbXFBDtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 23:49:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Emmanuel Fust? <emmanuel.fuste@laposte.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
References: <JIZ905$469B6EF277FE655A66C9ACE2321FC036@laposte.net>
	<m1sl9bxl7r.fsf@ebiederm.dsl.xmission.com>
	<20070602021906.GC13751@tree.beaverton.ibm.com>
Date: Fri, 01 Jun 2007 21:48:25 -0600
In-Reply-To: <20070602021906.GC13751@tree.beaverton.ibm.com> (Darrick
	J. Wong's message of "Fri, 1 Jun 2007 19:19:07 -0700")
Message-ID: <m1k5unxbhy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> writes:

> On Fri, Jun 01, 2007 at 06:18:32PM -0600, Eric W. Biederman wrote:
>
>> I doubt it.  The practical problem is that cpu_down does not
>> and by design can not call the irq balancing part properly
>> and I haven't yet seen anything to suggest that we don't migrate
>> irq properly.
>> 
>> So I'm guessing it was the decision part.
>
> I'm not using any IRQ balancer, afaik.  As I recall, CONFIG_IRQBALANCE
> is i386-only, and I'm not running the userland irqbalance program
> either.  Just messing around with /proc/irq/*/smp_affinity by hand. :)

This is just getting confusing.

Emmanuel Fust.  Please play with /proc/irq/*/smp_affinity by hand and
confirm that you can move your irqs.  This will confirm it is the decision
part.

Darrick.  The cpu hotplug architecture makes it impossible to properly
call irq migration code that backs /proc/irq/*/smp_affinity.  Therefore
the cpu hotplug interface to irq migration is broken by design.  There
are some other bugs in the implementation of migrating irqs off of cpus
as well.  I'm pretty certain that some combination of those problems is
biting you.

Eric

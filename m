Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXA2R4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXA2R4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXA2R4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:56:46 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33617 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXA2R4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:56:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
	<m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	<1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	<Pine.LNX.4.64.0701291017520.11801@d.namei>
Date: Mon, 29 Jan 2007 10:55:51 -0700
In-Reply-To: <Pine.LNX.4.64.0701291017520.11801@d.namei> (James Morris's
	message of "Mon, 29 Jan 2007 10:23:41 -0500 (EST)")
Message-ID: <m14pq9lntk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> writes:

> On Mon, 29 Jan 2007, Stephen Smalley wrote:
>
>> NAK.  Mapping all sysctls to a single security label prevents any kind
>> of fine-grained security on sysctls, and current policies already make
>> use of the current distinctions to limit access to particular sets of
>> sysctls to particular processes.  As is, I'd expect breakage of current
>> systems running SELinux from this patch, because (confined) processes
>> that formerly only required access to specific sysctl labels will
>> suddenly run into denials on the generic fallback label.
>
> Agreed, 100% NACK.
>
> Please don't just simply remove long-researched & analyzed MAC security 
> which has been in the kernel for years, which is being used in the field 
> for high assurance systems, because you neglected to consider it during a 
> code cleanup.

Please don't shoot the messenger when a weakness is found in your code.
Systems that increase security without worry that their implementation
is correct do not impress me, but I do understand that security has
little to do with correctness and everything to do with making it
_expensive_ for the other guy to do what he isn't supposed to.

This code path was always in the selinux code for when /proc was
compiled out.  I could see no way to preserve it so I removed
it.

Not knowing if it was a problem, or if we needed to do something more
I copied the people who did, at the first available opportunity.
Before this code makes it's way into peoples production systems.

Of course after all of the rants against path based security I was
amazed to find a code path that was using exactly that in selinux.
Equally I'm amazed that all of that long-researched and analysis of
the MAC security has not found these issues where you integrate with
the rest of the linux kernel.

I'm trying to make things correct, and simple and will be happy to
work with you in a way to achieve what you need in a way that does
not conflict with the rest of the kernel.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXA2TRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXA2TRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXA2TRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:17:53 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38628 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXA2TRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:17:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org
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
	<m18xflloes.fsf@ebiederm.dsl.xmission.com>
	<1170096231.8720.102.camel@moss-spartans.epoch.ncsc.mil>
Date: Mon, 29 Jan 2007 12:16:54 -0700
In-Reply-To: <1170096231.8720.102.camel@moss-spartans.epoch.ncsc.mil> (Stephen
	Smalley's message of "Mon, 29 Jan 2007 13:43:51 -0500")
Message-ID: <m1d54xk5i1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:


>> > If the ctl_table supplied more information about the functional purpose
>> > and the security sensitivity of the sysctl, then we could leverage that
>> > information instead, as long as we can at least derive the current
>> > labelings from that information for compatibility.
>> 
>> What do information do you need to do need?  Do you need extra fields in
> sysctl?
>> I am more than willing to help but I am not familiar enough with selinux
>> to do a reasonable job on my own.
>
> At present, we map the sysctls into functional groups (e.g. net, vm,
> fs, ...) that parallel the sysctl hierarchy so that we can limit access
> to only those programs/processes that need access for their purpose, and
> further partition where it makes sense to do so.  We also separate out
> particularly security sensitive ones like modprobe and hotplug.  So if
> the ctl_table carried some indication of functional grouping and
> security relevance (for some relatively small number of equivalence
> classes), then we could map those to labels instead of the current
> scheme.  And if we could have the ctl_table inherit the information from
> its logical "parent" in the hierarchy by default, then it shouldn't
> require too invasive a patch.

Ok.  So basically what you need is a parent pointer or some other way
of getting the full sysctl_path.   All of the names that show up in /proc
are still present in the ctl_table.

Hmm.  In parse_table we actually call sysctl_perm at each path component,
I'm not doing that in proc_sysctl.c at the moment but that would be easy to
add.

I think I will look at adding the back pointers.  Adding the security
check during lookup is nice but it won't really give you the context
you could use.  There may be a point in adding a security check during
lookup as well, but I think the way the VFS works there are weird implications
there.

Eric

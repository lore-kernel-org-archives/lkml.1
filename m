Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbXLJO7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbXLJO7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXLJO66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:58:58 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:33377 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbXLJO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:58:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAAbjXEdMROHU/2dsb2JhbACBWg
Date: Mon, 10 Dec 2007 09:58:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] Instrumentation menu removal, against
	2.6.24-rc4-mm1 (mmotm)
Message-ID: <20071210145854.GC2082@Krystal>
References: <20071208153255.078261362@polymtl.ca> <20071210085741.GA8437@in.ibm.com> <20071210094336.GB8437@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071210094336.GB8437@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:50:01 up 36 days, 19:55,  3 users,  load average: 0.94, 0.55,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> On Mon, Dec 10, 2007 at 02:27:41PM +0530, Ananth N Mavinakayanahalli wrote:
> > On Sat, Dec 08, 2007 at 10:32:55AM -0500, Mathieu Desnoyers wrote:
> > > Hi Andrew,
> > > 
> > > This time I am taking no chance :
> > > 
> > > The instrumentation menu removal patchset here applies against 2.6.24-rc4-mm1
> > > _and_ against mmotm (dated : stamp-2007-12-05-15-24) without problem.
> > > 
> > > We should hopefully be able to stop racing against other architecture specific
> > > fixes done underneath. Please be aware that the following fix :
> > > 
> > > - fix-oprofile-configuration-breakage.patch
> > > 
> > > from MIPS did not show up in your mmotm tree. I guess you just sent it upstream
> > > without keeping it in your own tree. I have applied the content of this fix in
> > > my patchset (meaning : select HAVE_OPROFILE if !MIPS_MT_SMTC in
> > > add-have-oprofile.patch), but I think you might have a reject if you still have
> > > this fix-oprofile-configuration-breakage.patch in your local tree but not in
> > > mmotm.
> > 
> > Mathieu,
> > 
> > With this patchset, a `make defconfig' results in:
> > 
> > CONFIG_OPROFILE=y
> > CONFIG_HAVE_OPROFILE=y
> > CONFIG_KPROBES=y
> > CONFIG_HAVE_KPROBES=y
> > 
> > You probably also need to change the defconfigs...
> 
> Nevermind. If the intention is to key off the build based on CONFIG_<FOO>
> and have the CONFIG_HAVE_<FOO> settings just to make the config simpler,
> this change is fine. The side effect is just that the CONFIG_HAVE_<FOO>
> will still have default settings even when CONFIG_<FOO> is not set.
> 

On x86_32, a diff between defconfig before and after the patchset :

97a98,103
> CONFIG_PROFILING=y
> # CONFIG_MARKERS is not set
> CONFIG_OPROFILE=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_KPROBES=y
> CONFIG_HAVE_KPROBES=y
1401,1405d1406
< CONFIG_INSTRUMENTATION=y
< CONFIG_PROFILING=y
< CONFIG_OPROFILE=y
< CONFIG_KPROBES=y
< # CONFIG_MARKERS is not set

Shows the same result. As you explain in your message, the HAVE_* is
just a way to know if the architecture provides a feature. The menu
entry is CONFIG_<FOO>, which depends on CONFIG_HAVE_<FOO>, will allow
y/n/m selection.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

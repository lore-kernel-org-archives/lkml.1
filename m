Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZGBHSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZGBHSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZGBHR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:17:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:55567 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751567AbZGBHR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:17:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19x3mFOvVVxunIaFYS/dwzGmCSgVQoz+qJJb8hqIU
	Odkp2WSVEbKtgl
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090702064712.GA26690@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 09:17:56 +0200
Message-Id: <1246519076.6384.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 08:47 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Per $subject, this patch set only supports for the LIVE kernel.  
> > It adds support infrastructure for path discovery, load address 
> > lookup, and symbol generation of live kernel modules.
> > 
> > TODO includes resurrection of live annotation in perf top, and 
> > support for annotation and report generation of other than live 
> > modules.  As the patch set sits, Perf top can generate symbols 
> > from live binaries, but there's no live annotation capability yet.
> > 
> > patch1: perf_counter tools: Make symbol loading consistently return number of loaded symbols.
> > patch2: perf_counter tools: Add infrastructure to support loading of kernel module symbols
> > patch3: perf_counter tools: connect module support infrastructure to symbol loading infrastructure
> > patch4: perf_counter tools: Enable kernel module symbol loading in tools
> > 
> > Comments and suggestions most welcome.
> 
> Looks very nice! I've applied it with a few minor stylistic fixlets 
> and a tad more verbose changelogs.

Thanks!

(sorry about changelogs, I did stare at them, nothing spiffy happened)

> I'm wondering about the next step: couldnt we somehow guess at the 
> position of the vmlinux too, validate somehow that it corresponds to 
> the kernel we are running - and then use it automatically and by 
> default?

I don't know of a way to discover where the image lives.  Been pondering
that very thing, along with idiot-proofing.

> Plus, offline analysis would be nice as well i suspect - being able 
> to look at profiles on a different box?

Yes, that's high on my TODO.  I've been pondering a perf archive tool
that would package everything that's needed to do analysis on a
different box.  One big problem though, is that while you can easily
package vmlinux and modules, what about all the userland binaries?  A
large perf.data and/or debug info binaries can easily make transport
impractical enough.

After I resurrect (well, try) live annotation in top, I'll fiddle with
offline kernel analysis.

	-Mike


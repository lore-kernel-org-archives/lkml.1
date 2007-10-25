Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbXJYTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbXJYTRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXJYTR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:17:26 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55256 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752977AbXJYTRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:17:25 -0400
Date: Thu, 25 Oct 2007 15:17:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roland McGrath <roland@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Denys Vlasenko <vda.linux@googlemail.com>, systemtap@sources.redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20071025191722.GA6114@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal> <20070921133006.GF8964@redhat.com> <20070921133820.GD13129@Krystal> <20071015194120.GA22562@redhat.com> <20071015231209.GA18994@Krystal> <20071015235033.321E84D0389@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071015235033.321E84D0389@magilla.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:11:55 up 87 days, 19:30,  3 users,  load average: 0.60, 0.74, 0.67
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath (roland@redhat.com) wrote:
> > I think the main issue with the solution you propose is that it doesn't
> > deal with markers in modules, am I right ?
> 
> My suggestion applies as well to modules as anything else.  
> What "like Module.symvers" means is something like:
> 
> name1	vmlinux		%s
> name2	fs/nfs/nfs	%d
> 
> All the modules built by the same kernel build go into this one file.
> 
> Modules packaged separately for the same kernel could provide additional
> files of the same kind.
> 
> > I will soon come with a marker iterator and a module that provides a
> > userspace -and in kernel- interface to enable/disable markers. Actually,
> > I already have the code ready in my LTTng snapshots. I can provide a
> > link if you want to have a look.
> 
> That's clearly straightforward to do given the basic markers data structures.
> 
> It does not address the need for an offline list of markers available in a
> particular kernel build or set of modules that you are not running right now.
> The approach now available for that is grovelling through the markers data
> structures extracted from vmlinux and .ko ELF files offline.  That is more
> work than one should have to do, and has lots of problems with coping with
> different packaging details, etc.
> 

Since gcc is required to build the systemtap probes on the development
marchine, I don't see why it would be much harder to also require prople
to install drawf ? Or maybe the "crash" tool ?

I guess you must already need to extract the symbols for your kprobes.
Do you use kallsyms for this ? The way I see it, you could maybe extract
kallsyms symbols corresponding to the markers data structures quite
easily.

I would rather prefer not to implement superfluous built-time data
extraction in the kernel build system just to make userspace simpler. If
we can leverage what currently exists, that would be better.

Mathieu

> 
> Thanks,
> Roland

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

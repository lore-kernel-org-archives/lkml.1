Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYH0JAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYH0JAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYH0JAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:00:22 -0400
Received: from ns.firmix.at ([62.141.48.66]:1207 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbYH0JAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:00:20 -0400
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
From: Bernd Petrovitsch <bernd@firmix.at>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
In-Reply-To: <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	 <200808261111.19205.rusty@rustcorp.com.au>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 27 Aug 2008 11:00:09 +0200
Message-Id: <1219827609.30209.29.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.344 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.344 required=5
X-Spam-Score: -2.344 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 20:58 -0400, Parag Warudkar wrote:
[...]
> The savings part -financial ones- are not always realizable with the
> way memory is priced/sized/fitted.
> Savings in few Mb of Kernel stack are not necessarily going to allow
> getting rid of a single memory chip of 64M or so.

No, but you can put an additional service(s) on it and sales people have
one (or two or ....) line more for their sales brochures.

> Either that or embedded manufacturing/configurations are different
> than the desktop world.

They are different. Think of running the complete system acting as a
bridge, router and/or firewall (Kernel early 2.4 though) from 4MB flash
in 32MB RAM and - listing the outside visible services - having a
command-line interface, web-GUI (implying a http server) and and a
(net-)SNMP agent on it.
Running a glibc without thread support is win there (implying that there
is no thread support available on that device).

> (If my device has 2 memory slots and my user space requires 100Mb
> including kernel memory - I anyways have to put in 64Mx2 there to take
> advantage of mass manufactured, general purpose memory - so no big
> deal if I saved 1.2Mb in Kernel stack or not. And savings of 64Mb
> Kernel memory are not feasible anyways to allow user space to work
> with 64Mb.)

As soon as product management realizes that there is space left on the
device, they get new ideas and/or customer requirements to run more
services on that device.

> On the other hand reducing  user space memory usage on those devices
> (not counting savings from kernel stack size) is a way more attractive
> option.

There is no question if save space here or there. You save it - sooner
or later - on all fronts. Period.

> And although you said in your later reply that Linux x86 with 4K
> stacks should be more than usable - my experiences running a untainted
> desktop/file server with 4K stack have been always disastrous XFS or
> not.  It _might_ work for some well defined workloads but you would
> not want to risk 4K stacks otherwise.

The embedded world of really small devices usually doesn't run XFS (or
ext? or reiser* of jfs or NFS or ...) or stacks block devices on files
or .....

> I understand the having 4K stack option as a non-default for very
> specific workloads is a good idea but apart from that I think no one
> else seems to bother with reducing stack sizes (by no one I mean other
> OSes.)

They probably gave the idea pretty soon because you need to
rework/improve large parts of the kernel + drivers (and that has two
major problems - it consumes a lot of man power for "no new features and
everything must be completely tested again"[0] and it adds new risks).
And that is practically impossible if one sells "stable driver APIs" for
3rd party (commercial) drivers because these must be changed too.

	Bernd

[0]: Let alone if you (or your customers) need certificates from some
     governmental agencys.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services



Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbXJOXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbXJOXu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXJOXur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:50:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbXJOXup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:50:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Denys Vlasenko <vda.linux@googlemail.com>, systemtap@sources.redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
In-Reply-To: Mathieu Desnoyers's message of  Monday, 15 October 2007 19:12:09 -0400 <20071015231209.GA18994@Krystal>
References: <20070918211324.161373216@polymtl.ca>
	<20070919113737.GA18177@Krystal>
	<y0mtzpqvk1l.fsf@ton.toronto.redhat.com>
	<200709192132.00873.vda.linux@googlemail.com>
	<20070921125819.GA13129@Krystal>
	<20070921133006.GF8964@redhat.com>
	<20070921133820.GD13129@Krystal>
	<20071015194120.GA22562@redhat.com>
	<20071015231209.GA18994@Krystal>
X-Shopping-List: (1) Celtic Bog reinforcements
   (2) Jealous onion gumption
   (3) Lyrical infestations
Message-Id: <20071015235033.321E84D0389@magilla.localdomain>
Date: Mon, 15 Oct 2007 16:50:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the main issue with the solution you propose is that it doesn't
> deal with markers in modules, am I right ?

My suggestion applies as well to modules as anything else.  
What "like Module.symvers" means is something like:

name1	vmlinux		%s
name2	fs/nfs/nfs	%d

All the modules built by the same kernel build go into this one file.

Modules packaged separately for the same kernel could provide additional
files of the same kind.

> I will soon come with a marker iterator and a module that provides a
> userspace -and in kernel- interface to enable/disable markers. Actually,
> I already have the code ready in my LTTng snapshots. I can provide a
> link if you want to have a look.

That's clearly straightforward to do given the basic markers data structures.

It does not address the need for an offline list of markers available in a
particular kernel build or set of modules that you are not running right now.
The approach now available for that is grovelling through the markers data
structures extracted from vmlinux and .ko ELF files offline.  That is more
work than one should have to do, and has lots of problems with coping with
different packaging details, etc.


Thanks,
Roland

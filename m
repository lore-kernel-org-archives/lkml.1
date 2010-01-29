Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751Ab0A2Amz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0A2Amz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456Ab0A2Amy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:42:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:41330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0A2Amy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:42:54 -0500
Date: Thu, 28 Jan 2010 22:42:42 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/9] perf session: Create kernel maps in the constructor
Message-ID: <20100129004242.GC2499@ghostprotocols.net>
References: <1264633557-17597-1-git-send-email-acme@infradead.org>
 <1264633557-17597-4-git-send-email-acme@infradead.org>
 <4B60C9A6.10704@redhat.com>
 <20100127232936.GI12567@ghostprotocols.net>
 <4B61BB2D.70802@redhat.com>
 <20100128182951.GB2499@ghostprotocols.net>
 <4B61FABA.6000600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61FABA.6000600@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 28, 2010 at 03:59:38PM -0500, Masami Hiramatsu escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jan 28, 2010 at 11:28:29AM -0500, Masami Hiramatsu escreveu:

> >> Yeah, and if you can separate an interface only for handling symbols
> >> from debug/elf binaries, it will be helpful for me too.

> > It was done on this same series, now you can do as the patch at the end
> > of this message, that will be on my next series, does.
 
> Great! thank you!
<SNIP>
> > you'll get ipv6.ko located and loaded, mod->dso->long_name thus will
> > have the file to use with libdwarf and sym->start will have the
> > unrelocated address, and mod->start will have where ipv6 is loaded in
> > kernel space

> Oh, nice :-) Is that available for the modules which aren't loaded?

No it isn't, what usecase do you see where you would like to look at non
loaded modules? Traversing the /lib/modules passed can be made to just
create DSOs, not maps if we need it. Maps when created using one of these
DSOs would find them on the list.

> And yeah, I'd like to support modules and it will requires some
> enhancement in kprobe-tracer too.

Ok

<SNIP>
> > With the recent modifications done to untie the session and symbol
> > layers, 'perf probe' now can use just the symbols layer.

> Could you remove session.kmap too?
> other parts look good to me.

I'll haven't done that just to keep the patch as small as possible :-)
But will do before submitting.
 
> Thank you,

You're welcome,

- Arnaldo

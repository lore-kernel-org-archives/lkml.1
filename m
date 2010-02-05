Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab0BEGyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:54:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:44438 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933242Ab0BEGyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:54:41 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kXWEbT6SkMU7DzEFwrF2a+mhtUcJMjO3/tQUZdH
	ZUiPW9KFGZ4wwm
Subject: Re: [PATCH 8/9] perf annotate: fix it for non-prelinked *.so
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100204194851.GA12121@ghostprotocols.net>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
	 <1265223128-11786-8-git-send-email-acme@infradead.org>
	 <1265265106.6364.5.camel@marge.simson.net>
	 <20100204193403.GA22781@landau.phys.spbu.ru>
	 <20100204194851.GA12121@ghostprotocols.net>
Content-Type: text/plain
Date: Fri, 05 Feb 2010 07:54:38 +0100
Message-Id: <1265352878.14282.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 17:48 -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 04, 2010 at 10:34:04PM +0300, Kirill Smelkov escreveu:
> > On Thu, Feb 04, 2010 at 07:31:46AM +0100, Mike Galbraith wrote:
> > > Monkey see monkey do.
> > > 
> > > perf tools: fix perf top module symbol annotation.
> > >  		"objdump --start-address=0x%016Lx "
> > >  			 "--stop-address=0x%016Lx -dS %s",
> > > -		map->unmap_ip(map, sym->start),
> > > -		map->unmap_ip(map, sym->end), path);
> > > +		map__rip_2objdump(map, sym->start),
> > > +		map__rip_2objdump(map, sym->end), path);
> > 
> > If I recall correctly, that's not enough.
> > 
> > The problem is top code is also wrong at mapping objdump addresses to
> > absolute ip. That is another part of builtin-top.c which does
> > map->unmap_ip(), and I've already suggested a fix back at holidays:
> > 
> > http://marc.info/?l=linux-kernel&m=126295508002536&w=2
> 
> Yeah, I was looking at Mike's report about 'perf annotate' not working
> with modules, debugged, wrote a patch that looed at the ELF header obj
> type as the key to apply or not the unmap_ip operation and when it was
> working I thought I saw that patch somewhere, looked at yours and
> applied it instead.
> 
> Then I was testing your subsequent patches but had to call it a day,
> sent what I had that at least fixed 'annotate' and Mike took it from
> there.
> 
> Looking at this now.

Hm, seems to work fine.

(piddle)

Aha, the rest is needed for userland annotation to work.

	-Mike


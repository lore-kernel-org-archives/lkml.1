Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab0BDTtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:49:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab0BDTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:49:05 -0500
Date: Thu, 4 Feb 2010 17:48:51 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] perf annotate: fix it for non-prelinked *.so
Message-ID: <20100204194851.GA12121@ghostprotocols.net>
References: <1265223128-11786-1-git-send-email-acme@infradead.org> <1265223128-11786-8-git-send-email-acme@infradead.org> <1265265106.6364.5.camel@marge.simson.net> <20100204193403.GA22781@landau.phys.spbu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204193403.GA22781@landau.phys.spbu.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 04, 2010 at 10:34:04PM +0300, Kirill Smelkov escreveu:
> On Thu, Feb 04, 2010 at 07:31:46AM +0100, Mike Galbraith wrote:
> > Monkey see monkey do.
> > 
> > perf tools: fix perf top module symbol annotation.
> >  		"objdump --start-address=0x%016Lx "
> >  			 "--stop-address=0x%016Lx -dS %s",
> > -		map->unmap_ip(map, sym->start),
> > -		map->unmap_ip(map, sym->end), path);
> > +		map__rip_2objdump(map, sym->start),
> > +		map__rip_2objdump(map, sym->end), path);
> 
> If I recall correctly, that's not enough.
> 
> The problem is top code is also wrong at mapping objdump addresses to
> absolute ip. That is another part of builtin-top.c which does
> map->unmap_ip(), and I've already suggested a fix back at holidays:
> 
> http://marc.info/?l=linux-kernel&m=126295508002536&w=2

Yeah, I was looking at Mike's report about 'perf annotate' not working
with modules, debugged, wrote a patch that looed at the ELF header obj
type as the key to apply or not the unmap_ip operation and when it was
working I thought I saw that patch somewhere, looked at yours and
applied it instead.

Then I was testing your subsequent patches but had to call it a day,
sent what I had that at least fixed 'annotate' and Mike took it from
there.

Looking at this now.
 
- Arnaldo

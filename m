Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZDFR7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZDFR7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZDFR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:59:32 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:33938 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751917AbZDFR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:59:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYFAF/a2UlMQW1W/2dsb2JhbACBUslmhA8G
Date: Mon, 6 Apr 2009 13:58:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUGFIX][PATCH -tip] x86: fix text_poke to handle highmem pages
Message-ID: <20090406175807.GD31867@Krystal>
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com> <49D7AF26.5030808@redhat.com> <49D82987.5090003@redhat.com> <49DA37CB.4020901@redhat.com> <20090406173238.GA31867@Krystal> <49DA3F85.7050302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49DA3F85.7050302@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:55:07 up 37 days, 14:21,  1 user,  load average: 0.42, 0.56,
	0.53
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >> Fix a bug in text_poke to handle highmem pages, because module
> >> text pages are possible to be highmem pages on x86-32.
> >> In that case, since fixmap can't handle those pages, text_poke
> >> uses kmap_atomic.
> >>
> > 
> > Hrm, can you remind me what would be the downside of using kmap_atomic
> > in every scenarios (highmem and non-highmem) then ?
> 
> kmap_atomic can handle only highmem pages. If you passes lowmem pages,
> it returns just original vaddr of it. (because kmap is only for
> highmem support)
> 

OK, and if we are doing a second kmap_atomic() of a module text page
which is already mapped, does the second kmap_atomic return the vaddr of
the page originally mapped or is it creating a second mapping ?

Because if we ever decide to enforce read-only page mapping for module
text pages, touching highmem pages too, we will run into real trouble if
those happen to be the same page.

Mathieu

> > 
> > I would try to avoid "special cases" as much as possible, because they
> > just make problems harder to reproduce.
> 
> Actually, this bug is a special case because it happens only on PAE kernel.
> 
> > 
> > The idea would be to either add fixmap highmem support, or to simply use
> > kmap_atomic() for all cases until we add fixmap highmem support.
> > 
> 
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbZLOCWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbZLOCWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZLOCWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:22:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758433AbZLOCWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:22:16 -0500
Date: Tue, 15 Dec 2009 00:20:20 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Allow lookups by symbol name
	too
Message-ID: <20091215022020.GD21796@ghostprotocols.net>
References: <1260564622-12392-1-git-send-email-acme@infradead.org> <tip-79406cd789f745ac6aa9d597895f904a98a14007@git.kernel.org> <20091215021201.GB6048@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215021201.GB6048@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 15, 2009 at 03:12:03AM +0100, Frederic Weisbecker escreveu:
> On Sat, Dec 12, 2009 at 07:22:03AM +0000, tip-bot for Arnaldo Carvalho de Melo wrote:
> > Looking over the vmlinux/kallsyms is common enough that I'll add a
> > variable to the upcoming struct perf_session to avoid the need to
> > use map_groups__find_by_name to get the main vmlinux/kallsyms map.
> > 
> > The above example looks on the 'variable' symtab, but it is just
> > like that for the functions one.
> > 
> > Also the sort operation is done when we first use
> > map__find_symbol_by_name, in a lazy way.
> 
> It would be nice to also have a kernel symbol resolution
> helper independant of any session.
> 
> The problem is that I need to resolve a kernel variable symbol
> very early, when we parse record options. We don't have any
> session at this time so I can't retrieve the kmaps.

Humm, I don't think that is a problem, we just have to create the
session before processing the args, after all at record time we can use
kallsyms already.

> I'm not sure what's the proper way to handle that.

What is the problem? I'm not following :-)

- Arnaldo

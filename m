Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab0CLOFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:05:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:42144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0CLOFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:05:02 -0500
Date: Fri, 12 Mar 2010 10:56:10 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
Message-ID: <20100312135610.GA6965@ghostprotocols.net>
References: <1268349164-5822-1-git-send-email-acme@infradead.org>
 <1268349164-5822-5-git-send-email-acme@infradead.org>
 <1268376500.23887.9.camel@marge.simson.net>
 <1268377317.24910.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268377317.24910.1.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 12, 2010 at 08:01:57AM +0100, Mike Galbraith escreveu:
> On Fri, 2010-03-12 at 07:48 +0100, Mike Galbraith wrote:
> > On Thu, 2010-03-11 at 20:12 -0300, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > 
> > > In this initial patch it just checks if the output is a tty, if not it falls
> > > back to the previous behaviour, also if newt-devel/libnewt-dev is not installed
> > > the previous behaviour is maintaned.
> > > 
> > > Pressing enter on a symbol will annotate it, ESC in the annotation window will
> > > return to the report symbol list.
> > 
> > <build>
> > 
> > Oooooo, major case of happiness.  Nice!
> 
> On the fly event switching ala top in the oven?

Yeah, newt has a FormTimer thing that will exit if the user doesn't
press a key, that will be the time when we refresh the Listbox, etc.
When some key is pressed, we can use the opportunity to switch the
counter or to do annotation, sharing a widget with the report, etc.

Switching perf.data files should be possible, doing diffs using side by
side screens, etc. The widget should allow for N 'perf top' windows, one
per counter, so that we can monitor multiple counters at the same time,
going from live (perf top) to post morten (perf report), doing live
while collecting (perf top + perf record) for later, on another machine,
doing post morten (perf report) also should be possible, etc.

- Arnaldo

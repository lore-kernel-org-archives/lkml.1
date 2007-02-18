Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXBRXYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXBRXYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXBRXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:24:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXBRXYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:24:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Mon, 19 Feb 2007 00:19:21 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702181956.11273.rjw@sisk.pl> <20070218220134.GA4243@tv-sign.ru>
In-Reply-To: <20070218220134.GA4243@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702190019.23215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 23:01, Oleg Nesterov wrote:
> On 02/18, Rafael J. Wysocki wrote:
> > 
> > Appended is a patch that does something along these lines.  The necessary
> > thread_info flags are defined for i386 and x86_64, for now.
> 
> I'll try to look at this patch when I am not sooooo sleepy ...
> 
> just one small nit right now,
> 
> > --- linux-2.6.20-mm2.orig/include/asm-i386/thread_info.h	2007-02-18 19:49:34.000000000 +0100
> > +++ linux-2.6.20-mm2/include/asm-i386/thread_info.h	2007-02-18 19:50:37.000000000 +0100
> > @@ -135,6 +135,7 @@ static inline struct thread_info *curren
> >  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
> >  #define TIF_FREEZE		19	/* is freezing for suspend */
> >  #define TIF_FORCED_TF		20	/* true if TF in eflags artificially */
> > +#define TIF_FREEZER_SKIP	21	/* task freezer should not count us */
> 
> Do we need to put this flag into thread_info? It is always modified by
> "current", so it could live in task_struct->flags instead.

I thought we were running low on the task_struct->flags bits. :-)

Apart from this, we may need to set it from somewhere else in the future.

Greetings,
Rafael

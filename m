Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYGHSSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYGHSSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYGHSS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:18:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:57358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYGHSSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:18:25 -0400
Date: Tue, 8 Jul 2008 11:18:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 2/17] Add a WARN() macro that acts like WARN_ON()+printk
Message-ID: <20080708111822.3e143c5e@infradead.org>
In-Reply-To: <1215540006.5553.187.camel@localhost>
References: <20080708093800.274504ba@infradead.org>
	<20080708094023.260a31bb@infradead.org>
	<1215540006.5553.187.camel@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2008 11:00:05 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2008-07-08 at 09:40 -0700, Arjan van de Ven wrote:
> > +#ifndef WARN
> > +#define WARN(condition, format...)
> > ({					\
> > +	int __ret_warn_on
> > = !!(condition);				\
> > +	if
> > (unlikely(__ret_warn_on))					\
> > +
> > __WARN_printf(format);					\
> > +
> > unlikely(__ret_warn_on);					\
> > +}) +#endif
> > +
> 
> If all current uses of WARN are going to change, perhaps
> adding an argument for KERN_<level> or removing the
> KERN_<level> prefixes and standardizing on a single
> KERN_<level> (KERN_WARNING?) is appropriate.

I looked at this and there are various levels in use today, I don't
think we can standardize on one unfortunately.
I don't think there's a real problem; WARN() really acts like printk...
all the way.



If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

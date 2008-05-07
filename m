Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYEGNhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYEGNhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYEGNhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:37:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYEGNhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:37:34 -0400
Date: Wed, 7 May 2008 06:37:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/3] Add a WARN() macro; this is WARN_ON() + printk
 arguments
Message-ID: <20080507063720.7aa1baf7@infradead.org>
In-Reply-To: <19f34abd0805062341x21caa29dld03d838057d498e3@mail.gmail.com>
References: <20080506232017.247001e0@infradead.org>
	<20080506232113.7f066c26@infradead.org>
	<19f34abd0805062341x21caa29dld03d838057d498e3@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 08:41:31 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> Hi!
> 
> On Wed, May 7, 2008 at 8:21 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > Subject: Add a WARN() macro; this is WARN_ON() + printk arguments
> >  From: Arjan van de Ven <arjan@linux.intel.com>
> >
> >  Add a WARN() macro that acts like WARN_ON(), with the added
> > feature that it takes a printk like argument that is printed as
> > part of the warning message.
> 
> [...]
> 
> >  +#ifndef WARN
> >  +#define WARN(condition, format...)
> > ({                                          \
> >  +       int __ret_warn_on
> > = !!(condition);                              \
> >  +       if
> > (unlikely(__ret_warn_on))                                    \
> >  +
> > __WARN_printf(format);                                  \
> >  +
> > unlikely(__ret_warn_on);                                        \
> > +}) +#endif
> 
> Is there a good reason why this is not a static inline function? 

yes there is, and it's the same one that makes WARN_ON() not an inline
function (I tried); it's not possible to find a type for "condition"
that works for all callers.

> If WARN() is made a static inline, you can call
> __builtin_return_address(0) there and pass it into here instead. This
> seems like a kind of low-level internal function anyway, because of
> the file/line info.

if I could make it a static inline, I would make it an out of line
instead to save space ;)



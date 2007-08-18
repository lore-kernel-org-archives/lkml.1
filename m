Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXHRDcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXHRDcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 23:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXHRDby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 23:31:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbXHRDbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 23:31:53 -0400
Date: Fri, 17 Aug 2007 20:31:39 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] i386: optimize memset of 6 and 8 bytes
Message-ID: <20070817203139.61d1505b@freepuppy.rosehill.hemminger.net>
In-Reply-To: <1187402220.2789.2.camel@laptopd505.fenrus.org>
References: <20070817165030.5455f761@freepuppy.rosehill.hemminger.net>
	<1187401774.2789.0.camel@laptopd505.fenrus.org>
	<20070817185452.5cbf60c4@freepuppy.rosehill.hemminger.net>
	<1187402220.2789.2.camel@laptopd505.fenrus.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 18:57:00 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> 
> On Fri, 2007-08-17 at 18:54 -0700, Stephen Hemminger wrote:
> > On Fri, 17 Aug 2007 18:49:34 -0700
> > Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > 
> > > On Fri, 2007-08-17 at 16:50 -0700, Stephen Hemminger wrote:
> > > > Tne network code does memset for 6 and 8 byte values, that can easily
> > > > be optimized into simple assignments without string instructions.
> > > 
> > > 
> > > so... question.
> > > Why are we doing this by hand? Wouldn't gcc just generate this code in
> > > the first place (when using __builtin_memset)? I very much suspect it
> > > would (and if some version doesn't.... we really ought to get that
> > > fixed)
> > 
> > i386 and x86_64 are not using __builtin_memset, as least from the
> > code that I see generated.
> 
> .. maybe we should just fix it that way then?
> 
There probably is history behind the decision, like gcc problems
on some old compiler version.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

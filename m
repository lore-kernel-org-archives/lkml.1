Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXKNQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXKNQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXKNQQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:16:21 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:45217 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXKNQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:16:20 -0500
Date: Wed, 14 Nov 2007 17:16:13 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 improve and bugfix fasttimer
Message-ID: <20071114161613.GL6347@axis.com>
References: <20071108085430.GB6347@axis.com> <20071109151932.610bca4c.akpm@linux-foundation.org> <20071112154456.GH6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071112154456.GH6347@axis.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 04:44:56PM +0100, Jesper Nilsson wrote:
> On Fri, Nov 09, 2007 at 03:19:32PM -0800, Andrew Morton wrote:
> > >      if (timeval_cmp(&t->tv_expires, &tv) <= 0)
> >
> > You have a private timeval_cmp().  Please take a look at utilising
> > include/linux/time.h:timeval_compare() instead.  If that doesn't suit then
> > we'd entertain extensions of that interface.  Adding private code to do
> > something as common as this is not a good thing.

Unfortunately, the above code lies to us.

The comparison is no longer on timeval, but on a fasttimer_t,
which contains different data. The name is just a leftover from when
it was a timeval.

I'll change the name of the function to highlight this.

Best regards,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbXEIWoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbXEIWoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXEIWoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:44:37 -0400
Received: from waste.org ([66.93.16.53]:49502 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbXEIWog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:44:36 -0400
Date: Wed, 9 May 2007 17:44:23 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070509224423.GL11115@waste.org>
References: <4642389E.4080804@goop.org> <20070509215538.GK11115@waste.org> <46424896.8080506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46424896.8080506@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 03:17:58PM -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> >> Mercurial uses a strictly append-only model for updating its repo files,
> >> but it looks like maybe an append operation didn't stick.
> >>     
> >
> > (Unless you're using the mq extension, which regularly truncates
> > files. But you're definitely the first person to run into this sort of
> > thing in any case.)
> >   
> 
> Which I am, extensively, but not on the repo that got damaged.  That's
> why I was wondering about the nlink issues.  If I qpop a bunch of
> patches after just pushing them, won't it simply truncate the file?

Yep. But it will break links before doing that. Basically all opens go
through a function that breaks links.

-- 
Mathematics is the supreme nostalgia of our time.

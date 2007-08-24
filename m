Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbXHXCSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbXHXCSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765613AbXHXCS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:18:26 -0400
Received: from waste.org ([66.93.16.53]:56856 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbXHXCSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:18:25 -0400
Date: Thu, 23 Aug 2007 21:19:53 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, lode leroy <lode_leroy@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memchr (trivial) optimization
Message-ID: <20070824021953.GG21720@waste.org>
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl> <200708230213.21332.ioe-lkml@rameria.de> <20070824001351.GA20266@waste.org> <46CE2E61.9010408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE2E61.9010408@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 06:03:29PM -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> >   6e:   38 08                   cmp    %cl,(%eax)
> >   70:   74 07                   je     79 <memchr3+0x1b>
> >   72:   40                      inc    %eax
> >   
> It's a bit gross that the compiler is using inc here rather than lea or
> add, but still...
> 
> Er, something's spending 30% of its time in memchr?  This is not the
> code to fix.

Indeed. I'm just pointing out the general optimization of walking
one counter instead of two.

Hmm, perhaps the culprit is validate_nla?

-- 
Mathematics is the supreme nostalgia of our time.

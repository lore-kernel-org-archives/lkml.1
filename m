Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYBQKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYBQKJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYBQKJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:09:10 -0500
Received: from 1wt.eu ([62.212.114.60]:2004 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbYBQKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:09:09 -0500
Date: Sun, 17 Feb 2008 11:08:55 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andrew Pinski <pinskia@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linuxppc-dev@ozlabs.org,
       Roel Kluin <12o3l@tiscali.nl>, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Cbe-oss-dev] [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080217100855.GA5135@1wt.eu>
References: <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org> <20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org> <20080216175849.GA25636@1wt.eu> <de8d50360802170145u4bd60f76x9662b66c63bdf41d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de8d50360802170145u4bd60f76x9662b66c63bdf41d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:45:23AM -0800, Andrew Pinski wrote:
> On Feb 16, 2008 9:58 AM, Willy Tarreau <w@1wt.eu> wrote:
> > Last but not least, gcc 4 tends to emit stupid checks, to the point that I
> > have replaced unlikely(x) with (x) in my code when gcc >= 4 is detected. What
> > I observe is that the following code :
> >
> >     if (unlikely(p == NULL)) ...
> >
> > often gets coded like this :
> >
> >     reg1 = (p == NULL)
> >     if (reg1 != 0) ...
> >
> > ... which clobbers reg1 for nothing and performs a double test.
> 
> This really only can happen in GCC 4.0.x and 4.1.x and cannot happen
> for 4.2 or 4.3 really because of the way __builtin_expect is handled
> for those two.

Happy to know that, thanks for the info Andrew!

Willy


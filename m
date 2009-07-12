Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZGLWVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZGLWVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZGLWVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:21:33 -0400
Received: from n70.bullet.mail.sp1.yahoo.com ([98.136.44.38]:37337 "HELO
	n70.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751470AbZGLWVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:21:32 -0400
X-Yahoo-Newman-Id: 139103.22236.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g7G9D8ssPtq/J/XHfAfBWoI/GiC66wCo89uwTumS9nQZBbW0UCRlWAdWkKlgwzTuGbLuXdXC9/i6rYO3/oUUtnm7PrBeRTMR1MxaYIM8zZR2PfUd/NXcfOs/i/JBH5lKgrF0gArigoRkirROp5SZQOmHcaIlA/o/nnymbcpEa7w=  ;
X-YMail-OSG: yVT0d0IVM1mDI480U_GNUYkwuGrz7lpEiwb1BwekffOAedidVWVCfxIhILWiqoSRz7znjyS8CQaZOkwXisW9zywEc7UGpz_NxM00P86ucxA.XaTaMzHkLIhCkbb_exf0Yx2WTrv.cPXIfOBj3CgxQ92prF3qRMZRwbwiiSvnSzpOORNs0Zvs8eaQo_GuVGZZxINeF5n0jiYk.J4Bc9BjwhMRmIJFO.D02kDgpezhQnq3gW6obWpRTyVsplILJfM0aNE6neBQlcYP2.ZaFwjgS.4dn3lWnY7lMAT7puB4gFBZ74Zf.sta
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sun, 12 Jul 2009 15:21:30 -0700
User-Agent: KMail/1.9.10
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <20090712084734.GA944@flint.arm.linux.org.uk> <20090712131732.GA4406@flint.arm.linux.org.uk>
In-Reply-To: <20090712131732.GA4406@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907121521.31188.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Russell King wrote:
> 	 David's approach is an enhancement whereas your patches
> are a bug fix.

Not an enhancement.  Uwe's current approach causes regressions
in terms of kernel runtime footprint.  That is, pages will newly
be made to sit around doing *nothing* forever, when they could
have been used to get Real Work done.  And, pre-patches, they
would have been getting Real Work done.

If it weren't a regression I wouldn't have objected.

A few years back, I measured the impact of having probe() and
friends in a section -- init{,data} vs devinit{,data} -- that gets
removed.  Most drivers were in the 1K-2K range.  $SUBJECT was
larger than most, but there were some with even more discardable
init logic.

All that adds up.  There's no point to commiting patches that
do things wrong *and* waste space, then need to fix things up
again later when it's easy to do it right in the first place.



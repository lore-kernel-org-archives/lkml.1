Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYIDGio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYIDGio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYIDGif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:38:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:58288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYIDGif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:38:35 -0400
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for
	allocation by the reclaimer
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <48BEFAF9.3030006@linux-foundation.org>
References: <1220467452-15794-5-git-send-email-apw@shadowen.org>
	 <1220475206-23684-1-git-send-email-apw@shadowen.org>
	 <48BEFAF9.3030006@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 08:38:28 +0200
Message-Id: <1220510308.8609.167.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 16:00 -0500, Christoph Lameter wrote:
> Andy Whitcroft wrote:
> 
> >  
> >  #ifndef __GENERATING_BOUNDS_H
> > @@ -208,6 +211,9 @@ __PAGEFLAG(SlubDebug, slub_debug)
> >   */
> >  TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
> >  __PAGEFLAG(Buddy, buddy)
> > +PAGEFLAG(BuddyCapture, buddy_capture)	/* A buddy page, but reserved. */
> > +	__SETPAGEFLAG(BuddyCapture, buddy_capture)
> > +	__CLEARPAGEFLAG(BuddyCapture, buddy_capture)
> 
> Doesnt __PAGEFLAG do what you want without having to explicitly specify
> __SET/__CLEAR?

PAGEFLAG() __PAGEFLAG()

does TESTPAGEFLAG() double.


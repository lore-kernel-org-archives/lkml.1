Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbZFKPKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbZFKPKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761739AbZFKPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:09:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33630 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760320AbZFKPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:09:51 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com
In-Reply-To: <alpine.DEB.1.10.0906111040440.29827@gentwo.org>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
	 <1244534315.5024.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
	 <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>
	 <1244648659.23799.26.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906111040440.29827@gentwo.org>
Date: Thu, 11 Jun 2009 18:09:52 +0300
Message-Id: <1244732992.17483.54.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Pekka Enberg wrote:
> > Aha, SLUB thinks the minimum order for 4096 is 1. I guess you have
> > CONFIG_SLUB_DEBUG enabled? If yes, something like to following should
> > help. Christoph, are you okay with this patch?

On Thu, 2009-06-11 at 10:41 -0400, Christoph Lameter wrote:
> He likely has CONFIG_SLUB_DEBUG_ON set which enables debugging and thus
> needs more than the payload for metadata.

Yup. I suspect a lot of people who are doing _testing_ enable that. If
you're unhappy with my patch (the get_order one which shouldn't affect
that many caches anyway), any suggestions how to fix this up? It seems
that the wireless stack at least does quite a few kmalloc(4096)
allocations.

We can probably switch back to page allocator pass-through in the near
future (when Mel's patches are in) but we need a fix for -stable.

			Pekka


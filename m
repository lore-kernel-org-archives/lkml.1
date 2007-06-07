Return-Path: <linux-kernel-owner+w=401wt.eu-S1764065AbXFGTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764065AbXFGTz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934177AbXFGTzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:55:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47378 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934206AbXFGTzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:55:04 -0400
Subject: Re: [BUG] sysrq-m oops
From: john stultz <johnstul@us.ibm.com>
To: Bob Picco <bob.picco@hp.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Bernhard Walle <bwalle@suse.de>,
       acme@redhat.com, apw@shadowen.org
In-Reply-To: <20070607182122.GE11999@localhost>
References: <1181176035.6275.13.camel@localhost.localdomain>
	 <4668276E.4030504@redhat.com>  <20070607182122.GE11999@localhost>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 12:54:41 -0700
Message-Id: <1181246081.7621.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 14:21 -0400, Bob Picco wrote:
> Chuck Ebbert wrote:	[Thu Jun 07 2007, 11:42:38AM EDT]
> > On 06/06/2007 08:27 PM, john stultz wrote:
> > > Hey All,
> > > 	With 2.6.21 and the current -git, we're seeing the following oops when
> > > we try sysrq-m:
> > > 
> > 
> > It's here in arch/x86_64/mm/init.c::show_mem():
> > 
> >         for_each_online_pgdat(pgdat) {
> >                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
> This is probably with sparsemem? I'm working with acme@redhat.com to
> test a patch. Basically you need to validate the pfn because it
> could be in a hole. Most arches which support sparsemem perform this
> check.
> 
> 			if (!pfn_valid(pgdat->node_start_pfn + i))
> 				continue;


Yep. That catch avoids the issue! Sounds like a 2.6.21.x candidate.

thanks so much!
-john



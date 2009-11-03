Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZKCL2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZKCL2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZKCL2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:28:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbZKCL2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:28:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Date: Tue, 3 Nov 2009 12:30:20 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091102000855.F404.A69D9226@jp.fujitsu.com> <20091103002520.886C.A69D9226@jp.fujitsu.com> <4AEF4CF1.3020500@crca.org.au>
In-Reply-To: <4AEF4CF1.3020500@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031230.20344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009, Nigel Cunningham wrote:
> Hi.

Hi,

> KOSAKI Motohiro wrote:
> >> I haven't given much thought to numa awareness in hibernate code, but I
> >> can say that the shrink_all_memory interface is woefully inadequate as
> >> far as zone awareness goes. Since lowmem needs to be atomically restored
> >> before we can restore highmem, we really need to be able to ask for a
> >> particular number of pages of a particular zone type to be freed.
> > 
> > Honestly, I am not suspend/hibernation expert. Can I ask why caller need to know
> > per-zone number of freed pages information? if hibernation don't need highmem.
> > following incremental patch prevent highmem reclaim perfectly. Is it enough?
> 
> (Disclaimer: I don't think about highmem a lot any more, and might have
> forgotten some of the details, or swsusp's algorithms might have
> changed. Rafael might need to correct some of this...)
> 
> Imagine that you have a system with 1000 pages of lowmem and 5000 pages
> of highmem. Of these, 950 lowmem pages are in use and 500 highmem pages
> are in use.
> 
> In order to to be able to save an image, we need to be able to do an
> atomic copy of those lowmem pages.
> 
> You might think that we could just copy everything into the spare
> highmem pages, but we can't because mapping and unmapping the highmem
> pages as we copy the data will leave us with an inconsistent copy.

This isn't the case any more for the mainline hibernate code.  We use highmem
for storing image data as well as lowmem.

Thanks,
Rafael

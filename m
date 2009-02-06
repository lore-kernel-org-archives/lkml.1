Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZBFXkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZBFXkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZBFXke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:40:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33361 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBFXkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:40:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: hannes@cmpxchg.org
Subject: Re: [PATCH 0/3] swsusp: shrink file cache first
Date: Sat, 7 Feb 2009 00:39:53 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <E1LVFiv-00032p-HX@cmpxchg.org>
In-Reply-To: <E1LVFiv-00032p-HX@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902070039.54402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello!

Hi Hannes,
 
> here are three patches that adjust the memory shrinking code used for
> suspend-to-disk.
> 
> The first two patches are cleanups only and can probably go in
> regardless of the third one.
> 
> The third patch changes the shrink_all_memory() logic to drop the file
> cache first before touching any mapped files and only then goes for
> anon pages.
> 
> The reason is that everything not shrunk before suspension has to go
> into the image and will be 'prefaulted' before the processes can
> resume and the system is usable again, so the image should be small
> and contain only pages that are likely to be used right after resume
> again.  And this in turn means that the inactive file cache is the
> best point to start decimating used memory.
> 
> Also, right now, subsequent faults of contiguously mapped files are
> likely to perform better than swapin (see
> http://kernelnewbies.org/KernelProjects/SwapoutClustering), so not
> only file cache is preferred over other pages, but file pages over
> anon pages in general.
> 
> Testing up to this point shows that the patch does what is intended,
> shrinking file cache in favor of anon pages.  But whether the idea is
> correct to begin with is a bit hard to quantify and I am still working
> on it, so RFC only.

Thanks a lot for the patches, I'll review them as soon as I can.

I've got them with broken headers, but that's not a big deal.

Best,
Rafael

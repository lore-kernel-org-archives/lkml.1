Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYCNFmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYCNFmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYCNFmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:42:42 -0400
Received: from phunq.net ([64.81.85.152]:60528 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023AbYCNFmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:42:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 21:42:20 -0800
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803131923.14840.phillips@phunq.net> <47DA0B78.8010802@davidnewall.com>
In-Reply-To: <47DA0B78.8010802@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132242.21305.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 22:22, David Newall wrote:
> I'd like to seem some science.  I'd like to know how much faster it
> really is, and for that proper testing needs to be done.  Since Daniel's
> scheme uses the same amount of RAM as disk, an appropriate test would be
> to pin (at least) that amount of RAM to buffer cache, and then to fill
> the cache with the contents of the disk (i.e. cat /dev/disk >
> /dev/null.)  This sets the stage for tests, which tests should not
> include the sync operation.  I'd like to see actual numbers against such
> a setup versus Daniel's scheme.  Since buffer cache is shared by all
> disks, obviously the test must not access any other drive.

There is a correctable flaw in your experiment: loading the disk into
buffer cache does not make the cached data available to the page
cache.  Maybe it should (good summer project there for somebody) but
for now you need to tar the filesystem to dev/null or similar.  Note
that, because of poor cross-directory readahead, traversing a disk
like that will not be as fast as reading it linearly.  On the other
hand, you will not have to read any free space into cache, which
ramback does because it does not know what is free space (or care,
really...)

Anyway, your investigative attitude is worth gold :-)

> One thing I will admit: RAM disks are fast.  What I don't know is how
> much work there is to access blocks that are already in the buffer
> cache.  In principle I suppose it should be a little slower, but not
> much.  I'd like to know, though.  I'd do the test myself if I had a
> machine with enough RAM, but I don't.  Daniel (apparently) does...

You are probably OK.  I used a 150 MB ramdisk, of which I used only
100 MB.  That is why I used a 2.2 kernel for my tests.

Daniel

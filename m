Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZAEKcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZAEKcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZAEKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:32:41 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:24405 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751202AbZAEKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:32:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x0pQfFWXQEbNVbF+RDnQpghF9ComCEVwZFymCTiQCwMPam8gKRC56DksPH31UNWdO2vHJPacWy1l9KDeNJzHBTpqfVp2poO+1nQlVRnHBZKvLyIuV+mwWdOprTEI5qYMjOG8dMZsuNZhpBElu0fttmNVTbxjiZ2WMH2RkiftUOI=  ;
X-YMail-OSG: PVr.I54VM1ngqkggV8xF7u9ZiwWc7Ne6Tzq5QUJZv9e8WIbpWE1XE71nMMBiTXcK9U9aDU_vHP42rU6TmZE5bDVGShIYGBifcp3FKVNlAqGs8QmzbQtbBe6GtiACQWO18Ln5dpzaPvZcCLg3kBVVWtbluZC2sjb74quxLv5zO40sSyUPb1B_ACJNXXBUwYB3WEpruJhmOqR.kHM4whv6WFe1wSQY_OD.
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 5 Jan 2009 21:32:22 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20090103.013755.42849152.ryusuke@osrg.net> <1230925087.7538.41.camel@think.oraclecorp.com>
In-Reply-To: <1230925087.7538.41.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901052132.22620.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 06:38:07 Chris Mason wrote:
> On Sat, 2009-01-03 at 01:37 +0900, Ryusuke Konishi wrote:
> > Hi,
> >
> > On Wed, 31 Dec 2008 18:19:09 -0500, Chris Mason <chris.mason@oracle.com> 
wrote:
> > > This has only btrfs as a module and would be the fastest way to see
> > > the .c files.  btrfs doesn't have any changes outside of fs/Makefile
> > > and fs/Kconfig
>
> [ ... ]
>
> > In addition, there seem to be well-separated reusable routines such as
> > async-thread (enhanced workqueue) and extent_map.  Do you intend to
> > move these into lib/ or so?
>
> Sorry, looks like I hit send too soon that time.  The async-thread code
> is very self contained, and was intended for generic use.  Pushing that
> into lib is probably a good idea.
>
> The extent_map and extent_buffer code was also intended for generic use.
> It needs some love and care (making it work for blocksize != pagesize)
> before I'd suggest moving it out of fs/btrfs.

I'm yet to be convinced it is a good idea to use extents for this. Been a
long time since we visited the issue, but when you converted ext2 to use
the extent mapping stuff, it actually went slower, and complexity went up
a lot (IIRC possibly required allocations in the writeback path).

So I think it is a fine idea to live in btrfs until it is more proven and
found useful elsewhere.


Return-Path: <linux-kernel-owner+w=401wt.eu-S966687AbXIKUfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966687AbXIKUfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXIKUfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:35:22 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:20583 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932305AbXIKUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:35:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QvlfzYAg/WNvp6DpbCEExGQpx+cd+OsOqr5DjDiGwqRAx8kClER85QJd5s/2TWVizP4Xoce3QQVZlvcib5VF2drZwHaOcME4Q0DHWp3Sope5R5uI80CBJKXxr3YiO4v7Xal+xhoROKF5i6a4xLaieiA55L2oLEn8gI8uOye3YUM=  ;
X-YMail-OSG: NQInYrAVM1nu0EEMWWtcvHrHk3Mta_ZkqARMTD8kbJWRoL2pVjSTpE4LcdPhAulbBMAP5mxk4g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 14:53:41 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111144.48743.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111309250.25781@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111309250.25781@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111453.42650.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 06:11, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > It would be interesting to craft an attack. If you knew roughly the
> > layout and size of your dentry slab for example... maybe you could stat a
> > whole lot of files, then open one and keep it open (maybe post the fd to
> > a unix socket or something crazy!) when you think you have filled up a
> > couple of MB worth of them. Repeat the process until your movable zone is
> > gone. Or do the same things with pagetables, or task structs, or radix
> > tree nodes, etc.. these are the kinds of things I worry about (as well as
> > just the gradual natural degredation).
>
> I guess you would have to run that without my targeted slab reclaim
> patchset? Otherwise the slab that are in the way could be reclaimed and
> you could not produce your test case.

I didn't realise you had patches to move pinned dentries, radix tree nodes,
task structs, page tables etc. Did I miss them in your last patchset?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYHUHA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYHUHA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYHUHAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:00:48 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43248 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752473AbYHUHAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:00:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=nb1eQTz10XOM/t/BTYfxvguW+ZamfOPCyZGD0ZW2171esm+gacan0sDxP9XSrBrgGJtFHKXwPCTSwDixJziFM7VoybtPKWONV7Q8vu0aE210Yn1JlYj2LR3YIf5ZrFQ7Fde66zD1wnt51p0tXMkfNYMf4fOs4ookG+AkWVIDTcM=  ;
X-YMail-OSG: 4LYkB7EVM1ncxcDUcq0i_D_BN5kEZVtJIV7N.Tawi7cVoATuQVq9zVc8Gju8F2zylJ5eJw22C29FyJe._XTv02oOW2meQM9O._EdKNzxVH8RnrT5Szon55ukf7s6IS5ClBk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Thu, 21 Aug 2008 17:00:39 +1000
User-Agent: KMail/1.9.5
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <684252.68814.qm@web34508.mail.mud.yahoo.com> <20080821061443.GD5706@disturbed>
In-Reply-To: <20080821061443.GD5706@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808211700.39584.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 16:14, Dave Chinner wrote:

> I think that we need to issue explicit unplugs to get the log I/O
> dispatched the way we want on all elevators and stop trying to
> give elevators implicit hints by abusing the bio types and hoping
> they do the right thing....

FWIW, my explicit plugging idea is still hanging around in one of
Jens' block trees (actually he refreshed it a couple of months ago).

It provides an API for VM or filesystems to plug and unplug
requests coming out of the current process, and it can reduce the
need to idle the queue. Needs more performance analysis and tuning
though.

But existing plugging is below the level of the elevators, and should
only kick in for at most tens of ms at queue idle events, so it sounds
like it may not be your problem. Elevators will need some hint to give
priority to specific requests -- either via the current threads's io
priority, or information attached to bios.


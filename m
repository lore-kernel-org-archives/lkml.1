Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXHNH76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXHNH76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXHNH7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:59:42 -0400
Received: from mail.daysofwonder.com ([213.186.49.53]:55908 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbXHNH7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:59:40 -0400
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
From: Brice Figureau <brice+lklm@daysofwonder.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stewart Smith <stewart@mysql.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070814022529.GA11322@one.firstfloor.org>
References: <20070803123712.987126000@chello.nl>
	 <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	 <20070804063217.GA25069@elte.hu> <loom.20070805T190600-28@post.gmane.org>
	 <p734pjdmxsz.fsf@bingen.suse.de>
	 <1186389638.30448.29.camel@localhost.localdomain>
	 <1187055897.18858.31.camel@localhost.localdomain>
	 <20070814022529.GA11322@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 09:59:35 +0200
Message-Id: <1187078375.11811.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 04:25 +0200, Andi Kleen wrote:
> On Tue, Aug 14, 2007 at 11:44:56AM +1000, Stewart Smith wrote:
> > > Since the database fits in RAM, the only kind of access Mysql is doing
> > > is writing to the innodb log, the mysql binlog and finally to the innodb
> > > database files.
> > > There are certainly a whole lot of fsync'ing happening.
> > 
> > yes. Keep in mind that the binlog grows in file size too... so this has
> > to sync all the metadata as well (ick, i know).

Back in the first days of my original bug report I moved the binlogs to
another disk and it didn't change anything to my issue.

On Tue, 2007-08-14 at 04:25 +0200, Andi Kleen wrote:
> It might be an interesting experiment to see if it still happens
> with the file system remounted as ext2. ext2 has a much more 
> benign fsync than ext3.

Is it possible to perform a live remount of the fs on ext2 ?

Beside that, the RAID card has a battery backed RAM in write-back mode,
I was told that fsync don't really hurt in this case (moreover the fs is
mounted in journal=writeback mode).

I'll post soon blktrace files in the original bug report, this will show
exactly what is the disk workload in the baseline case _and_ in the
underload atypical case. Maybe that will help to shed some lights on the
issue?

Anyway, thanks,
-- 
Brice Figureau <brice+lklm@daysofwonder.com>


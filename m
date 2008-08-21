Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbYHUGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbYHUGA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYHUGAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:00:12 -0400
Received: from web34508.mail.mud.yahoo.com ([66.163.178.174]:31288 "HELO
	web34508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751072AbYHUGAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:00:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=5r9SCkn72plnsdxQRs0xpJlZrzvaxetZgzV6pKkSh2zjmQC53tqOVZo6dlA80pfPSqaUCkxB10gq/Sogj2JcRfQzD+NzuC1Mjd1+D7HZLqrZT7F2QBv/uKyz9h78YkvltVP7EKe9tbOmW2T2vWFGdZuct+40ZmsaeriSeV83k3c=;
X-YMail-OSG: gMal2EIVM1nqHJ6pLYmPKeWvFsK25Z5VCBFHtUYgKrXWUFZCNEU_wohlJ8Qhh6fCQwLHt6vARMmdrzve_WL12NP3kBCobppiwYo3Zm_YA6jYm7DrPrUDWfeMsRnATcLHoTTPLrhfR2braINm7HpngOw-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 20 Aug 2008 23:00:07 -0700 (PDT)
From: gus3 <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20080821051508.GB5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <684252.68814.qm@web34508.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 8/20/08, Dave Chinner <david@fromorbit.com> wrote:

> Ok, I thought it might be the tiny log, but it didn't
> improve anything
> here when increased the log size, or the log buffer size.
> 
> Looking at the block trace, I think elevator merging is
> somewhat busted. I'm
> seeing adjacent I/Os being dispatched without having been
> merged.  e.g:

[snip]

> Also, CFQ appears to not be merging WRITE_SYNC bios or
> issuing them
> with any urgency.  The result of this is that it stalls the
> XFS
> transaction subsystem by capturing all the log buffers in
> the
> elevator and not issuing them. e.g.:

[snip]

> The I/Os are merged, but there's still that 700ms delay
> before dispatch.
> i was looking at this a while back but didn't get to
> finishing it off.
> i.e.:
> 
> http://oss.sgi.com/archives/xfs/2008-01/msg00151.html
> http://oss.sgi.com/archives/xfs/2008-01/msg00152.html
> 
> I'll have a bit more of a look at this w.r.t to
> compilebench performance,
> because it seems like a similar set of problems that I was
> seeing back
> then...

I concur your observation, esp. w.r.t. XFS and CFQ clashing:

http://gus3.typepad.com/i_am_therefore_i_think/2008/07/finding-the-fas.html

CFQ is the default on most Linux systems AFAIK; for decent XFS performance one needs to switch to "noop" or "deadline". I wasn't sure if it was broken code, or simply base assumptions in conflict (XFS vs. CFQ). Your log output sheds light on the matter for me, thanks.

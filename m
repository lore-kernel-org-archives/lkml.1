Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbXLQO0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbXLQO0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXLQO0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:26:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59817 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXLQO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:26:23 -0500
Date: Mon, 17 Dec 2007 15:26:22 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Oledzki <olel@ans.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-ID: <20071217142622.GB6979@atrey.karlin.mff.cuni.cz>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <20071216135112.0b58ab74.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216135112.0b58ab74.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 16 Dec 2007 14:46:36 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> wrote:
> 
> > >>> Which filesystem, which mount options
> > >>
> > >>   - ext3 on RAID1 (MD): / - rootflags=data=journal
> > >
> > > It wouldn't surprise me if this is specific to data=journal: that
> > > journalling mode is pretty complex wrt dairty-data handling and isn't well
> > > tested.
> > >
> > > Does switching that to data=writeback change things?
> > 
> > I'll confirm this tomorrow but it seems that even switching to 
> > data=ordered (AFAIK default o ext3) is indeed enough to cure this problem.
> 
> yes, sorry, I meant ordered.
> 
> > Two questions remain then: why system dies when dirty reaches ~200MB 
> 
> I think you have ~2G of RAM and you're running with 
> /proc/sys/vm/dirty_ratio=10, yes?
> 
> If so, when that machine hits 10% * 2G of dirty memory then everyone who
> wants to dirty pages gets blocked.
> 
> > and what is wrong with ext3+data=journal with >=2.6.20-rc2?
> 
> Ah.  It has a bug in it ;)
> 
> As I said, data=journal has exceptional handling of pagecache data and is
> not well tested.  Someone (and I'm not sure who) will need to get in there
> and fix it.
  It seems fsx-linux is able to trigger the leak on my test machine so
I'll have a look into it (not sure if I'll get to it today but I should
find some time for it this week)...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

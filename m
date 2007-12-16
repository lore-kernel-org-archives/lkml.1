Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbXLPVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbXLPVwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758784AbXLPVwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:52:02 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbXLPVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:52:00 -0500
Date: Sun, 16 Dec 2007 13:51:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-Id: <20071216135112.0b58ab74.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
	<Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
	<20071215203539.d6f71e96.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl>
	<20071216015112.d0ab08a1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 14:46:36 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> wrote:

> >>> Which filesystem, which mount options
> >>
> >>   - ext3 on RAID1 (MD): / - rootflags=data=journal
> >
> > It wouldn't surprise me if this is specific to data=journal: that
> > journalling mode is pretty complex wrt dairty-data handling and isn't well
> > tested.
> >
> > Does switching that to data=writeback change things?
> 
> I'll confirm this tomorrow but it seems that even switching to 
> data=ordered (AFAIK default o ext3) is indeed enough to cure this problem.

yes, sorry, I meant ordered.

> Two questions remain then: why system dies when dirty reaches ~200MB 

I think you have ~2G of RAM and you're running with 
/proc/sys/vm/dirty_ratio=10, yes?

If so, when that machine hits 10% * 2G of dirty memory then everyone who
wants to dirty pages gets blocked.

> and what is wrong with ext3+data=journal with >=2.6.20-rc2?

Ah.  It has a bug in it ;)

As I said, data=journal has exceptional handling of pagecache data and is
not well tested.  Someone (and I'm not sure who) will need to get in there
and fix it.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZJTFZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZJTFZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZJTFZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:25:48 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:33172 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZJTFZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:25:46 -0400
Subject: Re: Question about invalidate_inode_pages2_range()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peng Tao <lkml.bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6149e97b0910190138k5791351dmc95d9cc636aaef2f@mail.gmail.com>
References: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
	 <1255940788.14447.7.camel@heimdal.trondhjem.org>
	 <6149e97b0910190138k5791351dmc95d9cc636aaef2f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 14:25:46 +0900
Message-Id: <1256016346.12592.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 2 sum rcpts/h 12 sum msgs/h 2 total rcpts 1717 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 90E0B3DAEBC4A240CE1809457309D8250DCEC779
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 8 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 16:38 +0800, Peng Tao wrote:
> On Mon, Oct 19, 2009 at 4:26 PM, Trond Myklebust
> <trond.myklebust@fys.uio.no> wrote:
> > On Mon, 2009-10-19 at 16:16 +0800, Peng Tao wrote:
> >> Hi,
> >>
> >> I've a question about invalidate_inode_pages2_range().
> >>
> >> When does invalidate_inode_pages2_range() returns -EBUSY? It locks and
> >> writes back the page. Why invalidate_complete_page2() still may fail
> >> due to page dirtiness?
> >
> > A lot of those requirements were set by NFS, which uses
> > invalidate_inode_pages2() in order to invalidate the page cache when it
> > detects that a file has been changed on the server (either due to an
> > O_DIRECT write, or due to another client modifying the file).
> >
> > In such cases, you want to try to keep the dirty data by writing it out
> > instead of discarding it.
> Thanks for your quick response. But I have two more questions about this.
> 1. invalidate_inode_pages2_range() calls wait_on_page_writeback().
> Does the latter actually write out the dirty page?

No. It just waits for any outstanding writeback activity on that page to
finish.

> 2. Is there any interface in the mm subsystem forces discarding a page cache?

You mean that also discards dirty pages? Yes. That is what
truncate_inode_pages() does...



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZJSI0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZJSI0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbZJSI0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:26:30 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:42827 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbZJSI0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:26:30 -0400
Subject: Re: Question about invalidate_inode_pages2_range()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peng Tao <lkml.bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
References: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 17:26:27 +0900
Message-Id: <1255940788.14447.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 2 msgs/h 1 sum rcpts/h 9 sum msgs/h 2 total rcpts 1695 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 14DD469B8759DDB2BDF17E74ED42E05BBE024A95
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 3 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 16:16 +0800, Peng Tao wrote:
> Hi,
> 
> I've a question about invalidate_inode_pages2_range().
> 
> When does invalidate_inode_pages2_range() returns -EBUSY? It locks and
> writes back the page. Why invalidate_complete_page2() still may fail
> due to page dirtiness?

A lot of those requirements were set by NFS, which uses
invalidate_inode_pages2() in order to invalidate the page cache when it
detects that a file has been changed on the server (either due to an
O_DIRECT write, or due to another client modifying the file).

In such cases, you want to try to keep the dirty data by writing it out
instead of discarding it.

Cheers
  Trond


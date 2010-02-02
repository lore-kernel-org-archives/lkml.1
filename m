Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0BBPEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:04:14 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:36551 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0BBPEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:04:10 -0500
Subject: Re: [PATCH] nfs: clear_commit_release incorrectly handle truncated
 page
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <87hbpzhqlp.fsf@openvz.org>
References: <87hbpzhqlp.fsf@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 10:04:05 -0500
Message-ID: <1265123045.3177.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 2332 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 25F36843540B4C0E580C7C28E25EAF010167703F
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 149 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:36 +0300, Dmitry Monakhov wrote: 
> After page was truncated it lost it's mapping, this result in null
> pointer dereference on bdi_stat update. In fact we have to decrement
> bdi_stat even for truncated pages, so let's pass correct mapping in
> function arguments. Patch against linux-2.6
> ##TEST_CASE
> /*
> Tast case for bug in nfs_clear_request_commit()
> caused by null pointer dereference in case of truncated page.
> It takes less than 10 minutes to reproduce the bug.

Something is wrong here. nfs_release_page() returns '0' if the 
page has an associated write request (i.e. PagePrivate is set), and so
both invalidate_complete_page() and invalidate_complete_page2() will
fail.

So what is truncating the page?

Trond


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYFPQzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYFPQzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYFPQy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:54:57 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:46474 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYFPQy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:54:57 -0400
Subject: Re: [PATCH] knfsd: nfsd: Handle ERESTARTSYS from syscalls.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chuck Lever <chucklever@gmail.com>
Cc: Peter Staubach <staubach@redhat.com>, NeilBrown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <76bd70e30806160809o495dd50fw88a80ec0673c0dc1@mail.gmail.com>
References: <20080613213759.26929.patches@notabene>
	 <1080613114215.27095@suse.de> <48565F19.10508@redhat.com>
	 <76bd70e30806160809o495dd50fw88a80ec0673c0dc1@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 12:54:46 -0400
Message-Id: <1213635286.7238.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 0034207E4433F11F16146A055334D05350FC21BC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 581 total 8956301 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 11:09 -0400, Chuck Lever wrote:

> I think an error reply is much better than no reply in nearly every
> case.  NFS3ERR_JUKEBOX/NFS4ERR_DELAY is an interesting idea, but
> something else again will probably be required for v4.1 with sessions.

NFS3ERR_JUKEBOX/NFS4ERR_DELAY may be inappropriate if the nfs daemon has
already started handling the RPC call, since you may be interrupting a
non-idempotent operation.

The only complete solution to this problem is NFSv4.1 with persistent
sessions.

Cheers
  Trond


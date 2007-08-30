Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbXH3Whb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbXH3Whb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbXH3WhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:37:19 -0400
Received: from pat.uio.no ([129.240.10.15]:48599 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762829AbXH3WhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:37:17 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
In-Reply-To: <000701c7eb49$cff701c0$6fe50540$@com>
References: <000701c7eb49$cff701c0$6fe50540$@com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 18:37:13 -0400
Message-Id: <1188513433.6626.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.078)
X-UiO-Scanned: 09A7D4C833041A8EE96B25402B2A88DA8CC1CDC1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 246 total 3573048 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 14:07 -0700, Hua Zhong wrote:
> I am re-sending this after help from Ian and git-bisect. To me it's a
> show-stopper: I cannot find an acceptable workaround that I can implement.
> 
> The problem: upgrading to 2.6.23-rc4 from 2.6.22 causes several autofs
> mounts to fail silently - they just not appear when they should.
> 
> I believe it's caused by the NFS change that forces multiple mounts from
> different directories under the same server side filesystem to have the same
> mount options by default, otherwise it returns EBUSY.
> 
> For example, if server has a filesystem /a, and it exports /a/x and /a/y
> (maybe with rw or ro), and a client must mount /a/x and /a/y with the same
> mount options now.

Which is better than having it fail silently, or giving you a mount with
the wrong mount options.

If you need to mount the same filesystem with incompatible mount options
on the same client, then there is a new mount option "nosharecache",
which enables it.
The new option is there in order to make it damned clear to sysadmins
that this is a dangerous thing to do: mounts which don't share the same
superblock also don't share the same data and attribute caches. Any file
or directory which appears in both mounts had better only be used by one
application at a time or be using an appropriate locking scheme.

Trond


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbXEJREc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbXEJREc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXEJRE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:04:26 -0400
Received: from pat.uio.no ([129.240.10.15]:57198 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbXEJREZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:04:25 -0400
Subject: RE: [PATCH] NLM program ID for user space NLM server
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Menny Hamburger <menny@exanet.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F59D8@hawk.exanet-il.co.il>
References: <A6FDE6B975803043804A49F12F49028E0F59D8@hawk.exanet-il.co.il>
Content-Type: text/plain
Date: Thu, 10 May 2007 13:04:21 -0400
Message-Id: <1178816661.6775.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.188)
X-UiO-Scanned: 7ED731DF98535DF5EE15E7D4F45C13290D48E1A4
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 76 total 1650470 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 19:45 +0300, Menny Hamburger wrote:
> Yes, but in our case we don't care. This is a dedicated server where we
> don't see any usage for NLM client. We just want to prevent the kernel
> from taking the port in case of some accidental NFS mount that ommitted
> 'nolock'. 

Which is _wrong_. If you omit the 'nolock' mount option, then the client
_does_ use NLM locking, and so will need the RPC downcall.

If you don't need NLM locking, and want to make sure nobody else can
enable it, then you can triviall 'fix' this on your server by patching
it to force the nolock mount option. This isn't a patch that we
particularly want to see in mainline, though.

Trond


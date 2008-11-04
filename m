Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYKDT0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYKDT0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYKDT0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:26:31 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:38079 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYKDT0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:26:30 -0500
Subject: Re: [PATCH] lockd: convert reclaimer thread to kthread interface
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20081104134235.0382c873@tleilax.poochiereds.net>
References: <1225278945-15407-1-git-send-email-jlayton@redhat.com>
	 <20081103131215.75a83236.akpm@linux-foundation.org>
	 <20081103191924.16528bfd@tleilax.poochiereds.net>
	 <1225802508.19864.2.camel@heimdal.trondhjem.org>
	 <20081104134235.0382c873@tleilax.poochiereds.net>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 14:26:21 -0500
Message-Id: <1225826781.30407.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 97D50A38E7EC6D167BCC3D3859B112CE053C7B41
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 172 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 13:42 -0500, Jeff Layton wrote:
> While we're on the subject of signals...
> 
> Do you have any thoughts/objections to just making the reclaimer thread
> ignore them altogether? That would simplify the code a bit.

How does the administrator then get out of the situation where the
server dies (permanently) in the middle of a reclaim?

Forced unmounts won't help here, since they only signal the NFS
requests, and are in any case per-filesystem, not per-server.

I suppose one could use soft RPC calls, but what should the retry policy
be for that case?

Trond


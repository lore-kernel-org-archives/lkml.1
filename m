Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbXIQNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbXIQNLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbXIQNK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:10:59 -0400
Received: from pat.uio.no ([129.240.10.15]:44861 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbXIQNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:10:56 -0400
Subject: Re: [NFS] [PATCH 2/7] NFS: if ATTR_KILL_S*ID bits are set, then
	skip mode change
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Greg Banks <gnb@sgi.com>
Cc: Jeff Layton <jlayton@redhat.com>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       nfs@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       unionfs@filesystems.org, linux-cifs-client@lists.samba.org
In-Reply-To: <20070914154345.GE25610@sgi.com>
References: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com>
	 <20070914102545.GF21965@sgi.com>
	 <20070914070258.8fccb40e.jlayton@redhat.com>
	 <20070914130924.GG21965@sgi.com>
	 <20070914093846.7cdd89da.jlayton@redhat.com>
	 <20070914144033.GD25610@sgi.com>
	 <20070914105838.efbfc45e.jlayton@redhat.com>
	 <20070914154345.GE25610@sgi.com>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 09:10:47 -0400
Message-Id: <1190034647.6700.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.106)
X-UiO-Scanned: 6A5F62439F4958FD2933370EE8ABB4E9915B2E86
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 407 total 3922677 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-15 at 01:43 +1000, Greg Banks wrote:
> On Fri, Sep 14, 2007 at 10:58:38AM -0400, Jeff Layton wrote:
> > If Irix isn't clearing these bits
> > on a write then it might be good to see if they can fix that...
> 
> I think first you'd have to mount a serious argument that it's broken,
> more serious than "it works differently from Linux".

How about: "If IRIX isn't clearing these bits then they're leaving their
customers wide open to all sorts of security issues."

Unless you make the chmod/chgrp atomic with the write, then there will
always be a way for a client to inject data while the setuid/setgid bits
are set: basically, it allows said client to rewrite a setuid/setgid
executable.

We're not fixing this in the client because it isn't fixable on the
client.

Trond


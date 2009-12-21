Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZLUSEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZLUSEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZLUSEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:04:54 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45600 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbZLUSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:04:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Date: Mon, 21 Dec 2009 11:04:43 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
In-reply-to: <Pine.LNX.4.64.0912192058390.8993@cobra.newdream.net>
To: Sage Weil <sage@newdream.net>
Cc: Valdis.Kletnieks@vt.edu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Message-id: <058D589B-3146-4A32-B739-F1462F5F79B3@sun.com>
X-Mailer: Apple Mail (2.936)
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net>
 <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
 <14397.1261200797@localhost>
 <Pine.LNX.4.64.0912192058390.8993@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-12-21, at 09:42, Sage Weil wrote:
> I think a compat/incompat flags mechanism during the
> initial handshake might be appropriate to make changes easier going
> forward.

Having compat/incompat flags for the network protocol, implemented  
correctly, is really critical for long term maintenance.  For Lustre,  
we ended up using a single set of compatibility flags:
- client sends full set of features that it understands
- server replies with strict subset of flags that it also understands
   (i.e. client_features & server_supported_features)
- if client doesn't have required support for a feature needed by the
   server, server refuses to allow client to mount
- if server doesn't have feature required by client (e.g. understands  
only
   some older implementation no longer supported by client), client  
refuses
   to mount filesystem

We've been able to use this mechanism for the past 5 years to maintain  
protocol interoperability for Lustre, though we don't promise  
perpetual interoperability, only for about 3 years or so before users  
have to upgrade to a newer release.  That allows us to drop support  
for ancient code instead of having to carry around baggage for every  
possible combination of old features.

Using simple version numbers for the protocol means you have to carry  
the baggage of every single previous version, and it isn't possible to  
have "experimental" features that are out in the wild, but eventually  
don't make sense to keep around forever.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


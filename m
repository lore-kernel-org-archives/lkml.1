Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZIUV14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZIUV14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZIUV14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:27:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbZIUV1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:27:55 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: fanotify as syscalls
Date: Mon, 21 Sep 2009 23:27:20 +0200
User-Agent: KMail/1.9.9
Cc: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
References: <20090912094110.GB24709@ioremap.net> <200909212204.51077.agruen@suse.de> <20090921202823.GB14700@shareable.org>
In-Reply-To: <20090921202823.GB14700@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909212327.20978.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 21 September 2009 22:28:23 Jamie Lokier wrote:
> It would be logical if fanotify could block and ack those [mount & umount
> events] in the same way as it can block and ack other accesses (with the
> usual filtering rules on which inodes trigger events, and which don't or are
> cached).

Hmm. To me, fanotify is about file contents first of all: this is what 
fanotify wants to be able to veto. Directory events seem reasonable to add 
for inotify compatibility, but I see no need for access decisions on them. 
Even less so for mounts and unmounts. (Besides, we can't hold any vfs locks 
while asking fanotify so those operations wouldn't be atomic, anyway.)

Thanks,
Andreas

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbXIEPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbXIEPxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbXIEPxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:53:07 -0400
Received: from pat.uio.no ([129.240.10.15]:58309 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbXIEPxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:53:06 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <3558.1189006671@redhat.com>
References: <1188996257.3119.7.camel@raven.themaw.net>
	 <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188577275.6649.133.camel@heimdal.trondhjem.org>
	 <5813.1188892468@redhat.com>   <3558.1189006671@redhat.com>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 16:50:14 +0100
Message-Id: <1189007414.13235.20.camel@gaula.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: DBB58005C679EC08206A8DC21F7947F6FD29A0F1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 998 total 3689502 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 16:37 +0100, David Howells wrote:
> Ian Kent <raven@themaw.net> wrote:
> 
> > But what about mounting with different protocol, tcp vs udp for example.
> 
> I was referring specifically to the R/O / R/W variants of the same mount.  Any
> flag variation that varies the way the NFS client talks to the NFS server must
> either result in a new superblock or be ignored.
> 
> David

We currently ignore remount requests that attempt to change the NFS
mount parameters. This is not new behaviour, BTW: it has always been the
case, and nobody has ever requested it.

The ro flag is different, and I agree that it should be moved to the
vfsmount structure. I'm hoping Dave Hansen's patches will be ready for
merging soon...

Trond


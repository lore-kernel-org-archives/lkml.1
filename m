Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbYECOfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbYECOfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbYECOe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:34:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669AbYECOeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:34:20 -0400
Message-ID: <481C77E8.8050002@redhat.com>
Date: Sat, 03 May 2008 09:34:16 -0500
From: Clark Williams <williams@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: preempt-rt, need old style rwlocks for systemtap
References: <20080503132327.GA28881@redhat.com>
In-Reply-To: <20080503132327.GA28881@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Frank Ch. Eigler wrote:
> Hi -
> 
> It has come to my attention that the preempt-rt patch suite
> deliberately defeats the potential concurrency intended by systemtap's
> use of rwlocks to permit concurrent readers of various data
> structures.  Since systemtap's probe handlers are all atomic,
> nonblocking, nonpreemptable, it does not seem like there is any
> real-time-oriented benefit in this.  What can we do to work around
> this and permit reader concurrency again in preempt-rt?
> 

The reason it "defeats" the concurrent behavior is that it's really complicated to
have concurrent readers with Priority Inheritance, so the initial cut of rtmutexes
serialized all lock accesses.

Steven has posted a patch for comment (with no takers yet) that implements r/w locks
with concurrent readers and PI. We've just started running it on the MRG RT kernel
with some success, but I wouldn't say that it's ready for prime time.

You're welcome to help test it though...

Clark

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgcd+gACgkQHyuj/+TTEp2JCwCg4ZhqdqHCb9SZM+zrkKcyohtL
2coAoKLyUGZnRKha5NH7UDrM1QsP5ZaE
=FQas
-----END PGP SIGNATURE-----

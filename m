Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbXF0M0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbXF0M0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757067AbXF0M0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:26:23 -0400
Received: from v035086.ppp.asahi-net.or.jp ([124.155.35.86]:7515 "HELO
	daikokuya.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1756388AbXF0M0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:26:22 -0400
Date: Wed, 27 Jun 2007 21:26:28 +0900
From: Neil Booth <neil@daikokuya.co.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627122628.GR7590@daikokuya.co.uk>
References: <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070626233226.GO7590@daikokuya.co.uk> <20070627001803.GJ21478@ftp.linux.org.uk> <20070627115245.GP7590@daikokuya.co.uk> <20070627121948.GN21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627121948.GN21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:-

> Egads...  After rereading that...  What a mess.
> 
> int foo(void)
> {
> 	static int a[1][0,2];
> }
> 
> is, AFAICS, allowed.  Reason:
> 	int a[0,2]
> is a VLA due to 6.7.5.2[4] (0,2 is not an ICE).  However, due to the language
> in the same section,
> 	int a[1][0,2]
> is *not* a VLA, since (a) 2 is an ICE and (b) its element type "has a known
> constant size" (it does - the value of 0,2 is certainly guaranteed to be 2).
> I.e., it's VM type, but not a VLA.  I.e. only the first part of 6.7.5.2[2]
> applies and we are actually fine.
> 
> 	So we can have a static single-element array of int [0,2], but
> not a plain static int [0,2].  Lovely, that...

DR 312 clarified the meaning of "known constant size"

   http://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_312.htm

in the sensible way, thankfully, so your example is actually invalid.

Neil.

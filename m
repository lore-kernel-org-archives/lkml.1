Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXF0Lwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXF0Lwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXF0Lwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:52:41 -0400
Received: from v035086.ppp.asahi-net.or.jp ([124.155.35.86]:7568 "HELO
	daikokuya.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751029AbXF0Lwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:52:40 -0400
Date: Wed, 27 Jun 2007 20:52:45 +0900
From: Neil Booth <neil@daikokuya.co.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627115245.GP7590@daikokuya.co.uk>
References: <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070626233226.GO7590@daikokuya.co.uk> <20070627001803.GJ21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627001803.GJ21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:-

> 
> sparse simply doesn't check that.  We don't have anything resembling
> support of VLA.  Note that check for integer constant expression
> has nothing to do with that;
> 
> 	int x[(int)(0.6 + 0.6)];
> 
> is valid (if stupid).

It isn't valid; it fails the test twice.  Both 0.6 are not "immediate
operands of casts".  Their sum is, but that's irrelevant.
Therefore the dimension is not an ICE and a diagnostic is required.

Neil.

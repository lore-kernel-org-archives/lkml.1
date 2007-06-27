Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbXF0RqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbXF0RqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbXF0RqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:46:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131AbXF0RqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:46:12 -0400
Date: Wed, 27 Jun 2007 10:45:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
In-Reply-To: <20070627172903.GB21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706271043570.8675@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
 <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
 <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
 <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org>
 <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk>
 <20070627121021.GQ7590@daikokuya.co.uk> <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
 <20070627172903.GB21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Al Viro wrote:
> 
> Eh...  I'd say that my variant for offsetof() is simply better - it usually
> directly turns into EXPR_VALUE, right in place, without rather convoluted
> work.  Aside of "should such cast be a constant integer expression"...

Umm. But sparse is meant to parse C code. Which very much includes *other* 
projects.

The kernel, for example, has its own offsetof. And yes, these days we use 
"__compiler_offsetof()", but we used to do

	#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)

and I seriously doubt that the kernel is the only one doing things like 
that.

		Linus

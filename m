Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXF0Nfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXF0Nfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXF0Nfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:35:37 -0400
Received: from v035086.ppp.asahi-net.or.jp ([124.155.35.86]:7430 "HELO
	daikokuya.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751330AbXF0Nfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:35:37 -0400
Date: Wed, 27 Jun 2007 22:35:46 +0900
From: Neil Booth <neil@daikokuya.co.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627133546.GC16758@daikokuya.co.uk>
References: <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <20070627123031.GO21478@ftp.linux.org.uk> <20070627125958.GA16758@daikokuya.co.uk> <20070627131823.GR21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627131823.GR21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:-

> 
> Son of a...  expand_comma() cannibalizes the node, should restore ->flags
> to 0 (same as other similar suckers).
> 
> > struct c { unsigned int c1: 1 ? 2: a++; };
> 
> Ditto for expand_conditional, but there we should preserve the original
> ->flags instead - might be non-zero and we ought to do that after
> expanding the taken branch...
> 
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Wed, 27 Jun 2007 09:10:54 -0400
> Subject: [PATCH] fix the missed cannibalizing simplifications
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Now I think I only see one class of issues; the following is valid
C99 (I believe that's what you intend to follow) but being rejected:

   struct a { int comma: 1 ? 2: (2, 3); };

It's invalid C90.

Neil.

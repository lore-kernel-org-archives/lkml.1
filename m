Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbXF0Ahu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbXF0Ahu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXF0Ahm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:37:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38295 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXF0Ahl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:37:41 -0400
Date: Wed, 27 Jun 2007 01:37:38 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627003737.GK21478@ftp.linux.org.uk>
References: <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070626233226.GO7590@daikokuya.co.uk> <20070627001803.GJ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706261721550.8675@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706261721550.8675@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 05:25:06PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 27 Jun 2007, Al Viro wrote:
> >
> > > extern int a;
> > > extern int as1[(a = 2)];
> > 
> > sparse simply doesn't check that.  We don't have anything resembling
> > support of VLA.
> 
> Well, the above has two bugs that sparse could notice _independently_ of 
> variable-sized arrays:
>  - assignment outside of a function
>  - variable size array that isn't an automatic variable

Right; what I'm saying is that we don't do any checks on array sizes at
all, mostly since nobody is brave enough to deal with VLAs (which we'll
have to do if we start doing that).
 
> (strictly speaking, that's not even a variable size - it's a constant 2, 
> just with a non-constant expression - maybe you misread the "=" as an 
> "==")

With == it would be a different bug ;-)

BTW, VLA can be not just auto variable - it can be used in derivation of
such (i.e. you can say int (*p)[n], just not for anything not in block
or prototype scope).  And $DEITY help us[1] when ({...}) comes into the
game, since it allows leaking types out of the scope they'd been
declared in...

[1] or gcc - it gets an ICE galore in that class of testcases

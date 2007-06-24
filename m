Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXFXVtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXFXVtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFXVtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:49:35 -0400
Received: from v035086.ppp.asahi-net.or.jp ([124.155.35.86]:7452 "HELO
	daikokuya.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751081AbXFXVtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:49:35 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2007 17:49:34 EDT
Date: Mon, 25 Jun 2007 06:42:53 +0900
From: Neil Booth <neil@daikokuya.co.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624214253.GL7590@daikokuya.co.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624203837.GE21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:-

> > See gcc.gnu.org/PR456 for more discussion.  Yes it's an old
> > bug...
> 
> Humm...  Right, so __builtin_offsetof() needs special treatment too.
> Oh, bugger.  Is
> 	offsetof(struct foo, a.x[n])
> a documented extension?  I _know_ that it's not promised by 7.17,
> but gcc eats it (and obviously that sucker requires extra treatment
> in that case).

I asked on comp.std.c about this; the feeling was that only identifiers
are intended to be permitted as the 2nd argument to offsetof.  If true
the standard has a very obscure way of stating something that could
be said much more simply.
 
> Parsing __builtin_offsetof() arguments is going to be fun ;-/  Right
> now sparse has it as a predefined macro, but if we want to do that
> kind of analysis, we need to really parse it.  OTOH, that's not
> such a big deal...  Parser would need to accept
> 	ident ( \[ expr \] | . ident )*

don't forget -> if you're going to accept extra stuff.  GCC forgot ->
with the parser rewrite, yes I filed a PR.

Neil.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbXHBUJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbXHBUJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXHBUI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:08:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbXHBUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:08:57 -0400
Date: Thu, 2 Aug 2007 21:08:56 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802200856.GO21089@ftp.linux.org.uk>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 09:55:51PM +0200, Guennadi Liakhovetski wrote:
> But do a
> 
> 	char c[4] = "0123";
> 
> and - a wonder - no warning.

And this is a correct behaviour.  You get a valid initialier for array;
see 6.7.8[14] for details.  Moreover, that kind of code is often
quite deliberate.

>No warning with gcc 3.3.2, 3.3.5, 3.4.5, 
> 4.1.2. I was told 4.2.x does produce a warning. Now do a
> 
> 	struct {
> 		char c[4];
> 		int i;
> 	} t;
> 	t.i = 0x12345678;
> 	strcpy(t.c, c);
> 
> and t.i is silently corrupted. Just wanted to ask if this is known, 
> really...

strcpy() from array that doesn't contain 0 is an undefined behaviour,
nothing new about that...

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXCNR7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXCNR7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXCNR7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:59:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41745 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbXCNR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:59:46 -0400
Date: Wed, 14 Mar 2007 17:59:36 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
Message-ID: <20070314175936.GM4095@ftp.linux.org.uk>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk> <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be> <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be> <20070314170720.GL4095@ftp.linux.org.uk> <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 10:30:31AM -0700, Linus Torvalds wrote:
> > Nope.  How can kconfig distinguish that from a boolean option in modular
> > driver?  bool *can* depend on tristate and be selected when tristate is
> > set to m.
> 
> Btw, this is one of those things that easily causes problems.
> 
> In many ways it would be nice if we had two different kinds of "bool": one 
> where "m" in the dependency chain means "y" is ok, and one where "m" means 
> "n".

*nod*

> Maybe not "bool" vs "mbool", but it might be nice to have
> 
> 	bool FB_PS3
> 		depends strictly on FB
> 
> ie a "depends strictly" refuses to upgrade a bool dependency from "m" to 
> "y", while a regular depends allows it.
> 
> Or something.. The "depends strictly on X" thing would really be just a 
> mental shorthand for "depends on (X)=y" (it's actually longer to type, but 
> I think it's a bit more intuitive, thus "mental shortcut").

There's a fun side question, though: what should allmodconfig do?  FB=m,
FB_PS3=n?  Or FB=y, FB_PS3=y?

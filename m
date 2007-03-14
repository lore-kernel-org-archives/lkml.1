Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXCNSZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXCNSZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932346AbXCNSZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:25:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59209 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbXCNSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:25:37 -0400
Date: Wed, 14 Mar 2007 18:25:28 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
Message-ID: <20070314182528.GN4095@ftp.linux.org.uk>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk> <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be> <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be> <20070314170720.GL4095@ftp.linux.org.uk> <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org> <20070314175936.GM4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141907290.28462@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0703141907290.28462@pademelon.sonytel.be>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 07:09:40PM +0100, Geert Uytterhoeven wrote:
> On Wed, 14 Mar 2007, Al Viro wrote:
> > On Wed, Mar 14, 2007 at 10:30:31AM -0700, Linus Torvalds wrote:
> > > Maybe not "bool" vs "mbool", but it might be nice to have
> > > 
> > > 	bool FB_PS3
> > > 		depends strictly on FB
> > > 
> > > ie a "depends strictly" refuses to upgrade a bool dependency from "m" to 
> > > "y", while a regular depends allows it.
> > > 
> > > Or something.. The "depends strictly on X" thing would really be just a 
> > > mental shorthand for "depends on (X)=y" (it's actually longer to type, but 
> > > I think it's a bit more intuitive, thus "mental shortcut").
> > 
> > There's a fun side question, though: what should allmodconfig do?  FB=m,
> > FB_PS3=n?  Or FB=y, FB_PS3=y?
> 
> >From `make help':
> | New config selecting modules when possible
> 
> FB can be a module, so FB=m, FB_PS3=n.
> 
> It doesn't say anything about things that can't be modules :-)
> 
> But I agree the chances of getting a system that doesn't work increase...

No, I realize what kind of behaviour we'll get if we go for dependency on
FB=y.  However, if we really introduce a new kconfig primitive, it might
make sense to teach allmodconfig to deal with it.

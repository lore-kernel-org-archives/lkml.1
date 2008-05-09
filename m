Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbYEIO0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbYEIO0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYEIO0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:26:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:34552 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751041AbYEIO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:26:29 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/U+m8CTlTUSobDORr3XymRXV7oLRxH3A2nHugJ5M
	O3Z0wI5N5ugDaF
Date: Fri, 9 May 2008 16:26:26 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, zippel@linux-m68k.org
Subject: Re: [Patch] hfsplus oops on image without extends
Message-ID: <20080509142626.GA20287@alice>
References: <20080507104244.GD2340@alice> <20080509131326.GA31089@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080509131326.GA31089@shadowen.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 16:25:26 up  4:32,  1 user,  load average: 0.12, 0.05, 0.06
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andy Whitcroft (apw@shadowen.org) wrote:
> On Wed, May 07, 2008 at 12:42:44PM +0200, Eric Sesterhenn wrote:
> > hi,
> > 
> > the following patch fixes an oops with a corrupted hfs+ image.
> > see http://bugzilla.kernel.org/show_bug.cgi?id=10548 for details.
> > 
> > Problem is that we call hfs_btree_open() from hfsplus_fill_super() to set
> > HFSPLUS_SB(sb).[ext_tree|cat_tree]
> > Both trees are still NULL at this moment. If hfs_btree_open() fails for
> > any reason it calls iput() on the page, which
> > gets to hfsplus_releasepage() which tries to access HFSPLUS_SB(sb).*
> > which is still NULL and oopses while dereferencing it.
> 
> Erm, I presume this is meant to be 'if', checkpatch whined about the
> space as it thought it was a function.  I guess this hasn't been compile
> tested?

sorry, i messed this up, didnt have the original patch anymore and
quickly recreated it. Andrew already put a fix in -mm

Greetings, Eric

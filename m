Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXBDD4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXBDD4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXBDD4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:56:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:60762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXBDD4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:56:05 -0500
Date: Sun, 4 Feb 2007 04:55:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 1/9] fs: libfs buffered write leak fix
Message-ID: <20070204035549.GA3502@wotan.suse.de>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070129081914.23584.23886.sendpatchset@linux.site> <20070202155236.dae54aa2.akpm@linux-foundation.org> <20070203013316.GB27300@wotan.suse.de> <20070203174947.GA2656@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070203174947.GA2656@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 05:49:47PM +0000, Jörn Engel wrote:
> On Sat, 3 February 2007 02:33:16 +0100, Nick Piggin wrote:
> > 
> > If doing a partial-write, simply clear the whole page and set it uptodate
> > (don't need to get too tricky).
> 
> That sounds just like a bug I recently fixed in logfs.  prepare_write()
> would clear the page, commit_write() would write the whole page.  Bug
> can be reproduced with a simple testcate:
> 
> echo -n foo > foo
> echo -n bar >> foo
> cat foo
> 
> With the bug, the second write will replace "foo" with "\0\0\0" and
> cat will return "bar".  Doing a read instead of clearing the page will
> return "foobar", as would be expected.
> 
> Can you hit the same bug with your patch or did I miss something?

Yes, the page is only cleared if it is not uptodate. This is fine
for the simple filesystems.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbXLVVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbXLVVuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 16:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXLVVul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 16:50:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43801 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbXLVVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 16:50:40 -0500
Date: Sat, 22 Dec 2007 21:50:09 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222215009.GN8181@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 01:00:09PM -0800, Linus Torvalds wrote:

> > Another problem with using /sys/slab is that it is downright *ugly*.
> > Why is it for example, that /sys/slab/dentry is a symlink to
> > ../slab/:a-0000160?
> 
> That's the only really ugly thing there. Otherwise, it's pretty nice, but 
> having a million files makes for problems when trying to send somebody 
> else the full info. 

*raised brows*

I would say that there's that really ugly thing with embedding kobject
into a struct with the lifetime rules of its own and then having that
struct kfree()d while kobject might still have references, but hey,
maybe it's just me and my lack of appreciation of the glory that is
sysfs.

	Al, too tired of ranting about sysfs being a major architecture
mistake and a recurring source of turds like that one...

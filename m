Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXL0U2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXL0U2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 15:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXL0U2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 15:28:23 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35251 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbXL0U2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 15:28:22 -0500
Date: Thu, 27 Dec 2007 12:28:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: SLUB sysfs support
In-Reply-To: <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
References: <20071222192550.GD28891@thunk.org>
 <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
 <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
 <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
 <20071226221631.GD27894@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm.. If I separately allocate the kobject then I can no longer get to 
the kmem_cache structure from the kobject. 

I need to add a second kobject_del to sysfs_slab_remove() to make sysfs 
completely forget about the object?

Probably should track down any remaining symlinks at that point and nuke 
them too. Isnt there some way to convince sysfs to remove the symlinks 
if the target vanishes?






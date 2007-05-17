Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbXEQVz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbXEQVz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXEQVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:55:20 -0400
Received: from lazybastard.de ([212.112.238.170]:52969 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbXEQVzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:55:19 -0400
Date: Thu, 17 May 2007 23:50:58 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       akpm@osdl.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517215057.GH15676@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070516132035.GJ5472@lazybastard.org> <464CC209.4060500@cs.helsinki.fi> <200705172336.14552.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705172336.14552.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 23:36:13 +0200, Arnd Bergmann wrote:
> On Thursday 17 May 2007, Pekka Enberg wrote:
> > 
> > So any sane way to enable compression is on per-inode basis which makes 
> > me still wonder why you need per-object compression.
> 
> 1. it doesn't require user interaction, the file system will do the right
> thing most of the time.
> 
> 2. enlarging data is a very bad thing because it makes the behaviour
> of the fs unpredictable. With uncompressed objects, you have a guaranteed
> upper bound on the size.

Correct.  The compression decision is always per-object.  Per-inode is a
hint from userspace that a compression attempt would be futile.

A compression algorithm that compresses any data is provably impossible.
Some data will always cause expansion instead of compression.  Some
algorithms have a well-known upper bound on the expansion, others don't.
So LogFS instead creates its own upper bound by reserving one byte in
the header for the compression type.

And while one bit would suffice as a compressed/uncompressed flag,
having a byte allows to support more than one compression algorithm.
LZO looks promising and is on its way into the kernel.  Others may come
in the future.

Jörn

-- 
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra

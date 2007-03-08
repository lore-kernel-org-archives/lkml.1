Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXCHVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXCHVQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933357AbXCHVQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:16:18 -0500
Received: from mylar.outflux.net ([69.93.193.226]:58146 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbXCHVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:16:16 -0500
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 16:16:16 EST
Date: Thu, 8 Mar 2007 12:55:25 -0800
From: Kees Cook <kees@outflux.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070308205525.GJ6805@outflux.net>
References: <20070307012234.GN9621@outflux.net> <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org> <20070307031429.GU9621@outflux.net> <1173241331.3236.10.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173241331.3236.10.camel@laptopd505.fenrus.org>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 08:22:11PM -0800, Arjan van de Ven wrote:
> > [Adding Cc:lkml]
> 
> > How about using a reduced check, as is done for fd and environ?  This 
> > would allow root-running system monitors to still do their job.  
> > Effectively, this changes the test from "is ptracing" to just "can 
> > ptrace".
> > 
> > If this still isn't considered safe, I'll add the maps_protect file...
> 
> btw I consider it an information leak that any user can see which
> files/libraries any other user and root has mmap'd. (and with glibc's
> stdio mmap feature that goes even beyond direct mmap to fopen()'d).
> 
> If root or some other user wants to watch
> hillary-vs-obama-in-the-mud.avi, no other user has ANY business even
> seeing that. So at minimum it's a privacy issue showing the filenames...

So, what's the state of this?  Is the reduced "allowed to ptrace" check 
good enough for inclusion?  What is needed for some form of this patch 
to be included?  I'm happy to try new approaches if I can get some 
further input.

Another suggestion was to make this an ELF header toggle, and I'm 
generally against that idea.  If a toggle is needed, I'd rather it be a 
system-wide one.

-- 
Kees Cook

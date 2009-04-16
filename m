Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZDPKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZDPKsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZDPKsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:48:00 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35610 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZDPKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:48:00 -0400
Date: Thu, 16 Apr 2009 11:47:58 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090416104758.GA433@sucs.org>
References: <20090415205926.GA28246@sucs.org> <20090416041945.GK21586@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416041945.GK21586@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 12:19:45AM -0400, Theodore Tso wrote:
> On Wed, Apr 15, 2009 at 09:59:26PM +0100, Andrew Price wrote:
> > Using rootfstype=ext4 with today's linux-2.6.git causes a panic on my
> > two amd64 machines (haven't tested it on any others). 
> 
> Hmm, git commit id, please? 

commit 3ee8da87ba6151ec91b2b8bbd27633bb248ea0d5
Merge: a2c252e 9dd175f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Apr 15 09:11:11 2009 -0700

> The stack traces are in the IDE interrupt
> handler, so it seems surprising that ext4 would trigger it but ext3
> would not.  Have you tried ext4 on any earlier kernel?

It happened with linux-2.6.git kernels earlier in the week when I
started trying rootfstype=ext4 but I haven't tried properly bisecting it
yet.

> The main difference I can think of is that ext4 enables barriers by
> default; maybe that's the case of the IDE breakage?  Can you try
> booting with the boot command option "rootfsflags=barrier=0" as well
> as "rootfstype=ext4", and see if that helps?

I added rootflags=barrier=0 ...

(aside: the ext4 docs say the param is "barriers" with an s; it isn't).

... and it doesn't panic.

> If so, it's a bug in the IDE code in that it's not handling barriers
> correctly.

Bingo.

--
Andrew Price

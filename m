Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbXE2QCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbXE2QCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXE2QCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:02:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:37976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXE2QCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:02:16 -0400
To: "M Macnair" <mmacnair@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 May 2007 18:58:59 +0200
In-Reply-To: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
Message-ID: <p73zm3nefcc.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"M Macnair" <mmacnair@gmail.com> writes:
> 
> Many distros ship with an init script that saves and restores the
> entropy pool on startup and shutdown.  The bit that interests me that
> is called on startup is (my comments):
> 	if [ -f $random_seed ]; then
> 		cat $random_seed >/dev/urandom  # should seed the pool
OA
Writing doesn't actually work; to get real accounted entropy for /dev/random
you need to use a special ioctl. I ran into this problem some years ago 
and ended up writing http://www.muc.de/~ak/rndfeed.c

-Andi

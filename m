Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYI2Xkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYI2Xkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYI2Xkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:40:43 -0400
Received: from waste.org ([66.93.16.53]:55210 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYI2Xkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:40:42 -0400
Subject: Re: [RFC PATCH 1/2] Shrink compat_ioctl.c
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080929233842.GW25711@one.firstfloor.org>
References: <1222730830.23159.12.camel@calx>
	 <20080929233842.GW25711@one.firstfloor.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 18:38:02 -0500
Message-Id: <1222731482.23159.23.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 01:38 +0200, Andi Kleen wrote:
> On Mon, Sep 29, 2008 at 06:27:10PM -0500, Matt Mackall wrote:
> > I'm throwing this out untested as I don't have a mixed 64/32 system
> > handy at the moment.
> 
> Makes sense (assuming it works, haven't tested)
> 
> > compat_ioctl: shrink structures
> > 
> > Initially, compat_ioctl.c has a ~18k table of translated ioctls.
> > Each table entry is 24 bytes but we can shrink this to 16:
> > 
> > - use short table indexes rather than a pointer for .next values
> > - use unsigned ints for cmd numbers (they're 32-bit ioctls, after all)
> > 
> > In addition, there's a 2k hash table that we can do away with simply
> > by hashifying the main table in place at init time.
> 
> You mean by using a closed hash?

The original hash table was 256 pointers into the main table. I simply
rearrange the main table so the first 256 entries have an appropriate
hash. Basically:

for i in len(table):
  h = hash(table[i])
  swap(table[i], table[hash])

At the end of this loop, table[0:256] will contain an appropriate table
entry, if it exists. So no secondary table is needed.

-- 
Mathematics is the supreme nostalgia of our time.


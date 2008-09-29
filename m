Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYI2XdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYI2XdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYI2XdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:33:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46667 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYI2XdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:33:15 -0400
Date: Tue, 30 Sep 2008 01:38:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] Shrink compat_ioctl.c
Message-ID: <20080929233842.GW25711@one.firstfloor.org>
References: <1222730830.23159.12.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222730830.23159.12.camel@calx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 06:27:10PM -0500, Matt Mackall wrote:
> I'm throwing this out untested as I don't have a mixed 64/32 system
> handy at the moment.

Makes sense (assuming it works, haven't tested)

> compat_ioctl: shrink structures
> 
> Initially, compat_ioctl.c has a ~18k table of translated ioctls.
> Each table entry is 24 bytes but we can shrink this to 16:
> 
> - use short table indexes rather than a pointer for .next values
> - use unsigned ints for cmd numbers (they're 32-bit ioctls, after all)
> 
> In addition, there's a 2k hash table that we can do away with simply
> by hashifying the main table in place at init time.

You mean by using a closed hash?

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S937438AbXGTWfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937438AbXGTWfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXGTWfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:35:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbXGTWfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:35:02 -0400
Message-ID: <46A13859.7020608@zytor.com>
Date: Fri, 20 Jul 2007 15:34:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Andi Kleen <ak@suse.de>, Andreas Schwab <schwab@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
References: <617E1C2C70743745A92448908E030B2A01FA4C43@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01FA4C43@scsmsx411.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> At the moment our problem is that there is some code that has
> been added to handle the compatability problem caused by u64
> objects having different alignment when running on 32-bit and
> 64-bit systems.  This only affects ia64 and x86-64 because all
> the other 32/64 bit capable systems wisely avoided this issue
> by making 64-bit objects *always* 8-byte aligned.

> It is possible that in the future more such issues will arise
> (either because we find some more existing interfaces that
> have this problem, or because new interfaces are introduced
> that also have this problem).  Such new code will also require
> some compatability functions.  These functions will also only
> be needed on ia64 and x86-64, and even on these systems the
> code will only be needed if CONFIG_COMPAT=y

The issue here is I was looking at it from a new interfaces perspective,
and not from a legacy interfaces perspective.  However, for new
interfaces we want the opposite -- properly aligned elements -- so
please disregard previous objection.

However, I'm still thinking it might be worthwhile to consider the
__i[us]64 typedefs previously discussed as a way to avoid alignment
bloopers in new interfaces.

	-hpa

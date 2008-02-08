Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYBHXfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYBHXfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYBHXfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:35:07 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52365 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbYBHXfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:35:06 -0500
Date: Sat, 9 Feb 2008 02:35:08 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rth@twiddle.net, tony.luck@intel.com, anton@samba.org, paulus@samba.org,
       bunk@kernel.org, kamalesh@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] moduleparam: fix alpha, ia64 and ppc64 compile failures
Message-ID: <20080208233508.GA15610@jurassic.park.msu.ru>
References: <20080208223341.GB15333@jurassic.park.msu.ru> <20080208144615.9f2fc593.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208144615.9f2fc593.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 02:46:15PM -0800, Andrew Morton wrote:
> I think it would have been better to define a new CONFIG_MODULEPARAM_CONST
> for those three archictures, rather than muckying up the code like this.

I'd prefer to keep this as is for now (sorta the uglier the better ;-)
I really hope it's the short term solution as we need some feedback from gcc
folks. We use named sections quite a lot, but gcc is sort of unfriendly with
these, and this particular problem is not the main one.
For instance, if someone dares to put a 'switch' statement into discarded
section (__exit), the final link fails (on any arch!), because gcc generates
a jump table in .rodata which references that discarded section...

Ivan.

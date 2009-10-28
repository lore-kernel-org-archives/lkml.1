Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZJ1DvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZJ1DvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbZJ1DvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:51:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45982 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbZJ1DvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:51:17 -0400
Date: Wed, 28 Oct 2009 04:51:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, airlied@gmail.com, andi@firstfloor.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091028035121.GH7744@basil.fritz.box>
References: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com> <20091027.203838.21218679.davem@davemloft.net> <alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie> <20091027.204530.142024242.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027.204530.142024242.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 08:45:30PM -0700, David Miller wrote:
> From: Dave Airlie <airlied@linux.ie>
> Date: Wed, 28 Oct 2009 03:43:07 +0000 (GMT)
> 
> > we already opencoded this (probably before it was macroisied or we just 
> > pasted it), so the radeon one is buggy, I should just go and compat_* all 
> > of these then and we should be all happy?
> 
> It should be, it's only working because:
> 
> 1) A malicious userland hasn't put garbage in the upper bits for
>    you yet.

The x86 compat_ptr wouldn't even help with that because it doesn't mask.

If they use *_user() or anything else with access_ok later that should
be caught properly. The user land could only put in pointers to unmapped 
[32bit...kernel boundary] data, which is harmless.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

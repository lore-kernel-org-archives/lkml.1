Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZJ1Dms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZJ1Dms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZJ1Dmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:42:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47781
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbZJ1Dmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:42:46 -0400
Date: Tue, 27 Oct 2009 20:43:10 -0700 (PDT)
Message-Id: <20091027.204310.170866512.davem@davemloft.net>
To: andi@firstfloor.org
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091028033455.GF7744@basil.fritz.box>
References: <20091028031904.GA7744@basil.fritz.box>
	<21d7e9970910272028n6eaa21fap51f15511d51145a2@mail.gmail.com>
	<20091028033455.GF7744@basil.fritz.box>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 28 Oct 2009 04:34:55 +0100

> On Wed, Oct 28, 2009 at 01:28:10PM +1000, Dave Airlie wrote:
>> Well this was what I was trying to gather, so maybe I just need to write
>> something up to state that compat_ioctl is always required for new ioctls
>> that pass pointers or 64-bit values hiding pointers, so more people
>> don't make this mistake going forward. I can say when we inquired about this
>> 2 or so years ago when designing kms I didn't get this answer, which is a pity.
> 
> Right now you could probably ignore it (if you document it), since
> there are no non s390 architectures with this problem, just
> prepare mentally that you might need to revisit this at some point.

You can't ignore it on sparc64, it already OOPS's, and I refuse to
live with that "if (is_compat_task())" masking hack, no way.

We designed portable interfaces for doing this stuff, please use it.

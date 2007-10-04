Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXJDVHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXJDVHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbXJDVHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:07:40 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:35244 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761419AbXJDVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:07:39 -0400
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, akpm@linux-foundation.org, wfg@mail.ustc.edu.cn,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <1191516427.5574.7.camel@lappy> (message from Peter Zijlstra on
	Thu, 04 Oct 2007 18:47:07 +0200)
Subject: Re: [PATCH] remove throttle_vm_writeout()
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <1191501626.22357.14.camel@twins>
	 <E1IdQJn-0002Cv-00@dorka.pomaz.szeredi.hu>
	 <1191504186.22357.20.camel@twins>
	 <E1IdR58-0002Fq-00@dorka.pomaz.szeredi.hu> <1191516427.5574.7.camel@lappy>
Message-Id: <E1IdXuZ-0002Sk-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Oct 2007 23:07:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, I'm guestimating O on a per device basis, but I agree that the
> current ratio limiting is quite crude. I'm not at all sorry to see
> throttle_vm_writeback() go, I just wanted to make a point that what it
> does is not quite without merrit - we agree that it can be done better
> differently.

Yes.  So what is it to be?

Is limiting by device queues enough?

Or do we need some global limit?

If so, the cleanest way I see is to separately account and limit
swap-writeback pages, so the global counters don't interfere with the
limiting.

This shouldn't be hard to do, as we have the per-bdi writeback
counting infrastructure already, and also a pseudo bdi for swap in
swapper_space.backing_dev_info.

Miklos

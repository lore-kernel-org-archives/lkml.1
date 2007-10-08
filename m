Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbXJHNIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbXJHNIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXJHNI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:08:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:34743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbXJHNI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:08:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [5/6] scheduler: Protect important kernel threads against normalize_rt
Date: Mon, 8 Oct 2007 15:08:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710071059.126674000@suse.de> <200710081433.34845.ak@suse.de> <20071008124350.GA5779@elte.hu>
In-Reply-To: <20071008124350.GA5779@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081508.23950.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 14:43:50 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > softlockup is the same. Just think about it.
> > 
> > If you ever renormalize it and then run a fifo thread it will starve 
> > and then eventually kill the box.
> > 
> > And starving CPU unplug is also equally bad.
> 
> yeah, agreed. I ended up doing the change below.

I considered doing it this way too. But it means that if keventd
(or another workqueue thread) starts looping for some reason you cannot renormalize it.
Might be not a good thing and impact debuggability. I think it's better to only 
protect special threads.

-Andi

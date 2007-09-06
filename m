Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbXIFFhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbXIFFhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbXIFFg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:36:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45982 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbXIFFg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:36:56 -0400
Date: Thu, 6 Sep 2007 07:36:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: ext Andi Kleen <andi@firstfloor.org>,
       ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, davej@codemonkey.org.uk
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
Message-ID: <20070906053654.GD31880@one.firstfloor.org>
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com> <20070905102525.GB31880@one.firstfloor.org> <46DECDC9.9050407@nokia.com> <20070905163724.GC31880@one.firstfloor.org> <46DF0257.5050303@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DF0257.5050303@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This kernel boots up OK. Looking at the preprocessed C code the 

I assume you tested it a few times to make sure it really was the 
problem? Perhaps reenable it also once again and see if it hangs
again just to be sure.


> So what can we do about the clflush on this CPU?

I'll just remove that CLFLUSH statement. It was just supposed
to be an optimization, but is not strictly needed.

The only thing that worries me is that CLFLUSH might be broken
in more ways on those VIA CPUs and we also use it in other places.
Of course it would be possible to remove it from the kernel capabilities
but we can't really stop user space using it.  We don't know how many 
VIA CPU models are affected by this problem. Dave, didn't you have Centaur 
contacts that could be asked? It seems like CLFLUSH causes kernel 
hangs

-Andi


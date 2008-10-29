Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYJ2Knq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYJ2Knq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYJ2Kni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:43:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:37697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYJ2Knh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:43:37 -0400
Date: Wed, 29 Oct 2008 11:43:33 +0100
From: Nick Piggin <npiggin@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081029104333.GD5953@wotan.suse.de>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer> <20081029101145.GB5953@wotan.suse.de> <49083B14.6070402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49083B14.6070402@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 12:29:40PM +0200, Avi Kivity wrote:
> Nick Piggin wrote:
> >Hmm, spanning <30MB of memory... how much vmalloc space do you have?
> >
> >  
> 
> From the original report:
> 
> >VmallocTotal:     122880 kB
> >VmallocUsed:       15184 kB
> >VmallocChunk:      83764 kB
> 
> So it seems there's quite a bit of free space.
> 
> Chunk is the largest free contiguous region, right?  If so, it seems the 

Yes.


> problem is unrelated to guard pages, instead the search isn't finding a 
> 1-page area (with two guard pages) for some reason, even though lots of 
> free space is available.

Hmm. The free area search could be buggy...

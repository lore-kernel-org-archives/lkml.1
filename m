Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYJ2KaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYJ2KaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYJ2K3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:29:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYJ2K3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:29:52 -0400
Message-ID: <49083B14.6070402@redhat.com>
Date: Wed, 29 Oct 2008 12:29:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer> <20081029101145.GB5953@wotan.suse.de>
In-Reply-To: <20081029101145.GB5953@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hmm, spanning <30MB of memory... how much vmalloc space do you have?
>
>   

 From the original report:

> VmallocTotal:     122880 kB
> VmallocUsed:       15184 kB
> VmallocChunk:      83764 kB

So it seems there's quite a bit of free space.

Chunk is the largest free contiguous region, right?  If so, it seems the 
problem is unrelated to guard pages, instead the search isn't finding a 
1-page area (with two guard pages) for some reason, even though lots of 
free space is available.


-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYIXTs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYIXTs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYIXTsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:48:52 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43813 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYIXTsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:48:51 -0400
Date: Wed, 24 Sep 2008 20:41:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Matt Mackall <mpm@selenic.com>
cc: David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
In-Reply-To: <1222280971.4425.42.camel@calx>
Message-ID: <Pine.LNX.4.64.0809242030090.12147@blonde.site>
References: <20080923053228.GA5825@wotan.suse.de>  <20080914073906.GA6184@elte.hu>
  <20080914004442.4f8e851f.akpm@linux-foundation.org>  <20080914080631.GA10720@elte.hu>
 <20080914221231.GG27080@wotan.suse.de>  <20080917131419.e6b7622e.akpm@linux-foundation.org>
  <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org> 
 <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz> 
 <13787.1222095249@redhat.com>   <22749.1222280305@redhat.com>
 <1222280971.4425.42.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Matt Mackall wrote:
> 
> Is there any reason I shouldn't use truncate() in regular shmem.c if I
> were to unify the two files?

The lock ordering bug is a good reason not to use do_truncate()
in either.  Once Nick's fixup is in mainline, try the unification
based on that, including his #ifndef CONFIG_MMU which is good for
documentation.

But I don't know how ugly all the #ifdef'ing will end up: at the
time you created mm/tiny-shmem.c, we had a stronger embargo on
#ifdefs in *.c than is fashionable today.

If we're hell-bent on #ifdefs throughout mm/shmem.c, I wouldn't
mind scattering some CONFIG_SWAPs in there too, would cut out
lots of overhead when swap unconfigured.  But again, how ugly?

Hugh

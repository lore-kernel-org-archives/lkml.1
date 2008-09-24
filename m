Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYIXXps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYIXXps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYIXXpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:45:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56288 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYIXXpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:45:40 -0400
Date: Thu, 25 Sep 2008 00:43:37 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: David Howells <dhowells@redhat.com>
cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
In-Reply-To: <30202.1222286376@redhat.com>
Message-ID: <Pine.LNX.4.64.0809250035030.21674@blonde.site>
References: <Pine.LNX.4.64.0809242030090.12147@blonde.site>
 <20080923053228.GA5825@wotan.suse.de> <20080914073906.GA6184@elte.hu>
 <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu>
 <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org>
 <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org>
 <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz>
 <13787.1222095249@redhat.com> <22749.1222280305@redhat.com>
 <1222280971.4425.42.camel@calx>  <30202.1222286376@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, David Howells wrote:
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > If we're hell-bent on #ifdefs throughout mm/shmem.c, I wouldn't
> > mind scattering some CONFIG_SWAPs in there too, would cut out
> > lots of overhead when swap unconfigured.  But again, how ugly?
> 
> That might be necessary: NOMMU doesn't support swap.

Matt would be dealing with that aspect in his unification: SHMEM
depends on MMU, so !MMU gives you TINY_SHMEM - I'm sure he wouldn't
have any of the SWAP stuff in the TINY_SHMEM part of his unification.
But there's still value in adding CONFIG_SWAPs too (if the #ifdefs
were tolerable, by no means clear).

Hugh

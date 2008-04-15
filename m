Return-Path: <linux-kernel-owner+w=401wt.eu-S1764349AbYDOUzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764349AbYDOUzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYDOUyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:54:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60992 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752633AbYDOUyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:54:53 -0400
Date: Tue, 15 Apr 2008 13:54:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415201734.GA25628@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151319410.1785@schroedinger.engr.sgi.com>
References: <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
 <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
 <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Ingo Molnar wrote:

> my current guess would have been some bootmem regression/interaction 
> that messes up the buddy bitmaps - but i just reverted to the v2.6.24 
> version of bootmem.c and that crashes too ...

The simplest solution for now may be to go with your workaround increasing 
SECTION_SIZE_BITS to 27. PAE mode already uses 30 and x86_64 also works 
with 27. This is going to affect the memory hotplug granularity for !PAE 
32 bit configs though. Kame-san, any concerns with that?

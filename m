Return-Path: <linux-kernel-owner+w=401wt.eu-S1765868AbYEUGQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765868AbYEUGQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758415AbYEUGQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:16:07 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37685 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbYEUGQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:16:06 -0400
Date: Wed, 21 May 2008 10:15:32 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080521061531.GA27362@2ka.mipt.ru>
References: <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru> <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru> <20080520231942.GX103491721@sgi.com> <20080520162816.e5dfeffa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520162816.e5dfeffa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 04:28:16PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> It's more than efficiency.  There are lots and lots of things we cannot
> do in direct-reclaim context.
> 
> a) Can't lock pages (well we kinda sorta could, but generally code
>    will just trylock)
> 
> b) Cannot rely on the inode or the address_space being present in
>    memory after we have unlocked the page.
> 
> c) Cannot run iput().  Or at least, we couldn't five or six years
>    ago.  afaik nobody has investigated whether the situation is now
>    better or worse.
> 
> d) lots of deadlock scenarios - need to test __GFP_FS basically everywhere
>    in which you share code with normal writeback paths.
> 
> Plus e), f), g) and h).  Direct-reclaim is a hostile environment. 
> Things like b) are a real killer - nasty, subtle, rare,
> memory-pressure-dependent crashes.

Which basically means we can not do direct writeback at reclaim time?..

-- 
	Evgeniy Polyakov

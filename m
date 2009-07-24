Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZGXEsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZGXEsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZGXEsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:48:37 -0400
Received: from cobra.newdream.net ([66.33.216.30]:39632 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZGXEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:48:36 -0400
Date: Thu, 23 Jul 2009 21:48:36 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
In-Reply-To: <20090723191611.GE19207@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0907232145560.14156@cobra.newdream.net>
References: <1248292313-31326-2-git-send-email-sage@newdream.net>
 <1248292313-31326-3-git-send-email-sage@newdream.net>
 <1248292313-31326-4-git-send-email-sage@newdream.net>
 <1248292313-31326-5-git-send-email-sage@newdream.net>
 <1248292313-31326-6-git-send-email-sage@newdream.net>
 <1248292313-31326-7-git-send-email-sage@newdream.net>
 <1248292313-31326-8-git-send-email-sage@newdream.net>
 <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907231115190.2930@cobra.newdream.net> <20090723191611.GE19207@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Andi Kleen wrote:
> > There are two other memory allocations during writeout: a vector of pages 
> > to be written, and the message we're sending to the OSD.  If I use a 
> > mempool for those to guarantee as least some writeout will occur, how do I 
> > safely defer when allocations do fail?  Will pdflush (or it's replacement) 
> > eventually come back and try ->writepages() again?
> 
> mempool allocs should never fail, just block for a long time until
> someone else frees. This means you need to ensure of course you
> always make forward progress.

Oh, that avoids the issue reasonably well then.

Using mempools for the message passing is going to be a bit trickier (need 
to avoid any deadlocks due to dependencies on other messages), but it's 
doable.  At least in the limited case of making writeback proceed.

sage

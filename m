Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZGWTQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZGWTQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZGWTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:16:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60053 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZGWTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:16:12 -0400
Date: Thu, 23 Jul 2009 21:16:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
Message-ID: <20090723191611.GE19207@basil.fritz.box>
References: <1248292313-31326-2-git-send-email-sage@newdream.net> <1248292313-31326-3-git-send-email-sage@newdream.net> <1248292313-31326-4-git-send-email-sage@newdream.net> <1248292313-31326-5-git-send-email-sage@newdream.net> <1248292313-31326-6-git-send-email-sage@newdream.net> <1248292313-31326-7-git-send-email-sage@newdream.net> <1248292313-31326-8-git-send-email-sage@newdream.net> <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907231115190.2930@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907231115190.2930@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are two other memory allocations during writeout: a vector of pages 
> to be written, and the message we're sending to the OSD.  If I use a 
> mempool for those to guarantee as least some writeout will occur, how do I 
> safely defer when allocations do fail?  Will pdflush (or it's replacement) 
> eventually come back and try ->writepages() again?

mempool allocs should never fail, just block for a long time until
someone else frees. This means you need to ensure of course you
always make forward progress.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

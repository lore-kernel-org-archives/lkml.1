Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZDJIgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZDJIgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZDJIfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:35:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZDJIfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:35:50 -0400
Date: Fri, 10 Apr 2009 10:38:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean up sys_shutdown
Message-ID: <20090410083813.GQ14687@one.firstfloor.org>
References: <20090407223626.GA25557@basil.nowhere.org> <20090409221416.9a74f7fa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409221416.9a74f7fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 10:14:16PM -0700, Andrew Morton wrote:
> I wonder why this code uses lock_kernel().

I suspect because there's no other lock and parallel shutdowns
would be bad, but I wouldn't be surprised if there
aren't some caller without.

We could just convert it to a new global mutex or something.
I think it would be safe on x86, but I'm not sure about
all the other architectures.

Actually a simple flag would be enough that returns when
one is already in progress (that wouldn't work if parallel ones
fail, but that's presumably unlikely)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

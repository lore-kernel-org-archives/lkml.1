Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752354AbYLRQJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbYLRQJs (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYLRQJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:09:38 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45121 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYLRQJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:09:37 -0500
Message-ID: <494A74CA.7060403@cs.helsinki.fi>
Date: Thu, 18 Dec 2008 18:05:30 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 05/15] kmemleak: Add the slub memory allocation/freeing
 hooks
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>	 <20081210182721.30323.55530.stgit@pc1117.cambridge.arm.com>	 <4941866D.5040005@cs.helsinki.fi>	 <1229089544.15045.24.camel@pc1117.cambridge.arm.com>	 <1229597465.1047.54.camel@penberg-laptop> <1229614135.16418.33.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1229614135.16418.33.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas wrote:
> Just to make sure I understand it correctly, the slab_free() fast path
> stores the pointer to the freed object into c->freelist. However, this
> object is no longer tracked by kmemleak because of the
> kmemleak_free_recursive() call at the beginning of this function (false
> negatives make sense only for allocated objects).

Indeed. For SLAB, it's a problem because the per-CPU cache pointer is 
not cleared from the struct array_cache upon _allocation_ which is the 
culprit of the false negative there.

Catalin Marinas wrote:
> Is my understanding correct? Thanks.

Yes, it is and I was just confused. Thanks!

		Pekka

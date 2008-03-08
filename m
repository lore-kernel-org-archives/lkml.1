Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYCHMIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYCHMIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 07:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYCHMId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 07:08:33 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:15355 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYCHMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 07:08:32 -0500
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/7] Allow swiotlb to move block data bouncing to the block layer
References: <200803071013.837692778@firstfloor.org>
	<20080307091328.138F61B419C@basil.firstfloor.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Mar 2008 13:08:27 +0100
In-Reply-To: <20080307091328.138F61B419C@basil.firstfloor.org>
Message-ID: <87ve3xe7us.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Mar 2008 12:01:56.0809 (UTC) FILETIME=[34F88390:01C88114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> The block layer is generally in a better position to bounce
> than swiotlb because it is allowed to sleep at
> the right places. swiotlb cannot do that and is thus more prone
> to panic and failing on overflow.

[...]

The patch in this form right now is not a good idea. It really
depends on another patch which I had dropped from the public
posting. In the current form it would lead to all block swiotlb
bounces go through the low 16MB zone because block layer doesn't know
yet how to allocate bounce buffers above it and the block layer
would force it through its 16MB limited isa mempool.

I fixed that now properly for the next spin, with proper mask bouncing.

Anyways, just if anybody wants to test don't apply this patch
or use the latest patchkit from ftp://firstfloor.org/pub/ak/mask/patches/
which will bounce properly (and which also has some other improvements) 

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYFXIIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYFXIIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYFXIHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:07:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYFXIHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:07:46 -0400
Date: Tue, 24 Jun 2008 10:07:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <20080624080744.GL20851@kernel.dk>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24 2008, Mikulas Patocka wrote:
> Hi
> 
> bio_endio calls bi_end_io callback. In case of stacked devices (raid, dm), 
> bio_end_io may call bio_endio again, up to an unspecified length.
> 
> The crash because of stack overflow was really observed on sparc64. And 
> this recursion was one of the contributing factors (using 9 stack frames 
> --- that is 1728 bytes).

Looks good, I like the concept. Can you please make it a little less
goto driven, though? The next_bio and goto next_bio could just be a
while().

-- 
Jens Axboe


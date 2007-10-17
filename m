Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbXJQTQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbXJQTQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXJQTPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:15:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933293AbXJQTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:15:53 -0400
Date: Wed, 17 Oct 2007 12:15:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017190340.GW15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171211370.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
 <20071017180218.GQ15552@kernel.dk> <alpine.LFD.0.999.0710171111040.26902@woody.linux-foundation.org>
 <20071017182013.GR15552@kernel.dk> <alpine.LFD.0.999.0710171156060.26902@woody.linux-foundation.org>
 <20071017190340.GW15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> 
> Ah ok, I see why you are confused. The SCSI case is one, it allocs and
> frees the sg table each time. The entries are thus always initialized
> when they end up in blk_rq_map_sg(). However, other drivers allocate one
> at driver init time and use that one all the time. It needs to be
> initially cleared, but it wont be cleared before each request mapping.
> And that is fine, as long as we do clear entries in blk_rq_map_sg().

Ahh, ok, thanks for clearing that up.

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYKJQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYKJQEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYKJQEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:04:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbYKJQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:04:02 -0500
Date: Mon, 10 Nov 2008 08:03:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
In-Reply-To: <491835FF.1060403@kernel.org>
Message-ID: <alpine.LFD.2.00.0811100800420.3468@nehalem.linux-foundation.org>
References: <4917C449.2080504@kernel.org> <20081110120533.GB26778@kernel.dk> <491835FF.1060403@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Nov 2008, Tejun Heo wrote:
>
> I'm just a little bit nervous because libata always has had this tag 0 
> for non-NCQ commands assumption and this conversion changes that, so I 
> was hoping to update blk-tag such that such assumption can be guaranteed 
> first and then convert libata to be on the safe side.  Some controllers 
> use completely different command mechanism for different protocols and 
> it's much safer and more deterministic if same tag can be guaranteed.

Yeah, I think that's a good argument. Even when controllers expect tags, 
it's certainyl quite possible that all they've ever been tested with have 
always started tag allocation from zero, so while the "start at an offset" 
thing is fairly clever for other reasons, it probably was the wrong thing 
to do.

Maybe we can just have something count "outstanding async/sync requests".

			Linus

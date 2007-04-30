Return-Path: <linux-kernel-owner+w=401wt.eu-S1161631AbXD3Guh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161631AbXD3Guh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161649AbXD3Guh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:50:37 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8372 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161631AbXD3Gue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:50:34 -0400
Date: Mon, 30 Apr 2007 08:46:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@pobox.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-2.6-block.git] Fix blktrace trace ordering for plug  branch
Message-ID: <20070430064615.GB21015@kernel.dk>
References: <46325A6F.4050705@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46325A6F.4050705@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27 2007, Alan D. Brunelle wrote:
> The attached patch will correct the ordering of trace output between 
> request queue insertions (I) and unplug calls (U). Right now the insert 
> precedes the unplug, which just isn't right:
> 
> 65,128  0        1    67.699868965  7882  Q   R 0 + 1 [aiod]
> 65,128  0        2    67.699876462  7882  G   R 0 + 1 [aiod]
> 65,128  0        3    67.699878286  7882  P   W [aiod]
> 65,128  0        4    67.699880491  7882  I   R 0 + 1 [aiod]
> 65,128  0        5    67.699887589  7882  U   R [aiod] 1
> 65,128  0        6    67.699898317    54  D   R 0 + 1 [kblockd/0]
> 65,128  2      153    67.700126590     0  C   R 0 + 1 [0]
> 
> With the patch provided the unplug comes first:
> 
> 65,128  3        1     0.000000000  7045  Q   R 0 + 1 [aiod]
> 65,128  3        2     0.000002295  7045  G   R 0 + 1 [aiod]
> 65,128  3        3     0.000002617  7045  P   W [aiod]
> 65,128  3        4     0.000003685  7045  U   R [aiod] 1
> 65,128  3        5     0.000004107  7045  I   R 0 + 1 [aiod]
> 65,128  3        6     0.000009491    57  D   R 0 + 1 [kblockd/3]
> 65,128  2        1     0.000232447     0  C   R 0 + 1 [0]
> 
> Jens: If you agree, the patch can be applied to your plug branch for 
> git://git.kernel.dk/data/git/linux-2.6-block.git

Thanks, with that applied the unplug ordering should be the same after
the plugging changes. Applied.

-- 
Jens Axboe


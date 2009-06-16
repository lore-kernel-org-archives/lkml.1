Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZFPL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZFPL7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZFPL7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:59:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52116 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZFPL7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:59:15 -0400
Date: Tue, 16 Jun 2009 13:59:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Rottinger <steve@pentek.com>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090616115917.GX11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com> <20090604073218.GT11363@kernel.dk> <4A27CA0A.7060400@pentek.com> <c384c5ea0906121221p6a20d92fg6716f560164c46bf@mail.gmail.com> <4A32BE5B.7080503@pentek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A32BE5B.7080503@pentek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12 2009, Steve Rottinger wrote:
> Hi Leon,
> 
> It does seem like a lot of code needs to be executed to move a small
> chunk of data.

It's really not, you should try and benchmark the function call overhead
:-).

> Although,  I think that most of the overhead that I was experiencing
> came from the cumulative
> overhead of each splice system call.   I increased my pipe size using
> Jens' pipe size patch,
> from 16 to 256 pages, and this had a huge effect -- the speed of my
> transfers more than doubled.
> Pipe sizes larger that 256 pages, cause my kernel to crash.

Yes, the system call is more expensive. Increasing the pipe size can
definitely help there.

> I'm doing about 300MB/s to my hardware RAID, running two instances of my
> splice() copy application
> (One on each RAID channel).  I would like to combine the two RAID
> channels using a software RAID 0;
> however, splice, even from /dev/zero runs horribly slow to a software
> RAID device.  I'd be curious
> to know if anyone else has tried this?

Did you trace it and find out why it was slow? It should not be. Moving
300MB/sec should not be making any machine sweat.

-- 
Jens Axboe


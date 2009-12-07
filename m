Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZLGTct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZLGTct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbZLGTct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:32:49 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38036 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbZLGTcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:32:48 -0500
Date: Mon, 7 Dec 2009 20:32:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Ozan =?iso-8859-1?B?x2E/P2xheWFu?= <ozan@pardus.org.tr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Subject: Re: CCISS performance drop in buffered disk reads in newer kernels
Message-ID: <20091207193254.GF8742@kernel.dk>
References: <4B1CDCE6.5040502@pardus.org.tr> <0F5B06BAB751E047AB5C87D1F77A778869941207A5@GVW0547EXC.americas.hpqcorp.net> <4B1D47C5.7030804@pardus.org.tr> <20091207183946.GE8742@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77886994120A79@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77886994120A79@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07 2009, Miller, Mike (OS Dev) wrote:
> > > (max_hw_sectors_kb is 512 on my 2.6.25.20 setup and 1024 on 
> > 2.6.30.9 
> > > but it seems that it's read-only)
> > 
> > The *_hw_* values are the driver exported hardware limits, so 
> > they are always read-only.
> 
> Ahhh, I didn't know that. There is also an nr_requests attribute which
> to me implies limiting requests somewhere. The value of nr_request is
> 128 but the max commands to the cciss controllers exceed that value.
> What is nr_request supposed to do?

It controls what the block layer queue depth may be. As a rule of thumb,
it should be twice the hardware queue depth. A value of 128 means you
can have at most 128 reads and 128 writes queued in the IO scheduler. In
practice it's a bit more due to request allocation batching.

-- 
Jens Axboe


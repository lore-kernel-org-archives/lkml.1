Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZDXGPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZDXGPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZDXGPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:15:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41121 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZDXGPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:15:19 -0400
Date: Fri, 24 Apr 2009 08:15:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-2.6-block/for-linus] Fix discard requests
	accounting in the diskstats
Message-ID: <20090424061518.GY4593@kernel.dk>
References: <200904232013.n3NKD4PP017241@imap1.linux-foundation.org> <20090423140448.c2d34fb8.akpm@linux-foundation.org> <20090424051612.GT4593@kernel.dk> <200904241118.30919.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904241118.30919.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24 2009, Nikanth Karthikesan wrote:
> When 2 discard requests are merged, the stats gets updated, but we do not
> update statistics normally when a discard request is issued or completed. For
> example the in_flight counter would be decremented when 2 discard requests are
> merged, but it was not at all incremented when they were issued, and in_flight
> counter will not be decremented, when they are completed as well.
> 
> This patch fixes this by adding discard requests to the statistics.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

OK, so that's not quite what I had in mind. If we first do this as a
preparatory patch:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=42fd769da4edadad83a779867ff1910ec35c6de7

then the discard fix becomes this one-liner:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=999ae79ae7f853bb9e60e95753ebf8d1628e632a

-- 
Jens Axboe


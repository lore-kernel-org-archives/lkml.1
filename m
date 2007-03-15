Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXCOVwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXCOVwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXCOVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:52:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40010 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXCOVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:52:38 -0400
Date: Thu, 15 Mar 2007 21:52:33 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, devel@openvz.org
Subject: Re: [PATCH 1/2] mm: move common segment checks to separate helper function (v6)
Message-ID: <20070315215233.GA3523@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dmitriy Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>, devel@openvz.org
References: <878xe2rj0e.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878xe2rj0e.fsf@sw.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually thinking about this a little more I don't think we should put
this in.  Instead this loop should be moved up to fs/read_write.c because
these are checks that we want for all filesystems/drivers that use
vectored I/O.  We'll still need tiny loops to calculate the total
I/O length for now in every method, but that will be gone as soon
as we have our iodesc/uio/whatever structure.

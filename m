Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZAMDXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZAMDXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZAMDXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:23:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:33036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZAMDXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:23:33 -0500
Message-ID: <496C0915.6000107@kernel.org>
Date: Tue, 13 Jan 2009 12:23:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: new barrier warnings in 2.6.29-rc1
References: <20090112154634.GA15730@lst.de>
In-Reply-To: <20090112154634.GA15730@lst.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 03:23:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens)
Hello,

Christoph Hellwig wrote:
> Whever a filesystem submits a bio with the barrier flag set but
> the underlying hardware doesn't support it we now get errors in
> the form of:
> 
> [ 3046.442629] end_request: I/O error, dev vdb, sector 0
> 
> since commit a7384677b2f4cd40948fd7ce024ba5e1821444ba which removed
> the early check on the queue capabilities in __make_request.  I
> think this message is pretty annoying and confusing for the user
> as the filesystems already have more descriptive warnings, e.g. for
> XFS:
> 
> [ 3046.455478] Filesystem "vdb": Disabling barriers, trial barrier write failed

I think the right thing to do is setting REQ_QUIET on the trial
barrier request.

Thanks.

-- 
tejun

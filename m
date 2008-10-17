Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYJQGEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYJQGEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYJQGEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:04:31 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:49008 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbYJQGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:04:30 -0400
Date: Fri, 17 Oct 2008 11:34:25 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Message-ID: <20081017060424.GA26192@skywalker>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224201763-9637-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:02:43PM -0400, Theodore Ts'o wrote:
> The multiblock allocator needs to be able to release blocks (and issue
> a blkdev discard request) when the transaction which freed those
> blocks is committed.  Previously this was done via a polling mechanism
> when blocks are allocated or freed.  A much better way of doing things
> is to create a jbd2 callback function and attaching the list of blocks
> to be freed directly to the transaction structure.


Why not use journal commit callback patch from andreas 
(MID:20080929201752.GN10950@webber.adilger.int
http://article.gmane.org/gmane.comp.file-systems.ext4/9148)

The patch you sent will allows only one call back to be registered.

-aneesh

Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbZLJKjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbZLJKjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbZLJKjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:39:40 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35736 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625AbZLJKjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:39:39 -0500
Date: Thu, 10 Dec 2009 11:39:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, yinghai@kernel.org
Subject: Bisected regression (Was Re: current -git fails to boot on
	nehalem-ex)
Message-ID: <20091210103945.GI8742@kernel.dk>
References: <20091210091040.GG8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210091040.GG8742@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10 2009, Jens Axboe wrote:
> Hi,
> 
> As written in the subject, it just hard hangs before writing anything on
> the console. With earlyprintk, I captured the failure, see below.
> 
> I'll try and bisect this, but it takes some time (since the bios and
> post process takes forever). I just updated the firmware on the box as
> well, but it did boot 2.6.32 (and RHEL5 boots fine too). Of course that
> doesn't rule out a BIOS bug.

Results are persistent, git bisect points to:

commit b24c2a925a9837cccf54d50aeac22ba0cbc15455
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Tue Nov 24 02:48:18 2009 -0800

    x86: Move find_smp_config() earlier and avoid bootmem usage

which appears consistent with the panic(). Reverting that does indeed
make current -git boot properly.

-- 
Jens Axboe


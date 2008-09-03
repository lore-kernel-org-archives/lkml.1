Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYICQXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYICQXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYICQXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:23:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:50103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYICQXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:23:04 -0400
Message-ID: <48BEB98C.8030303@kernel.org>
Date: Wed, 03 Sep 2008 18:21:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com>
In-Reply-To: <48BEB759.4050503@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Sep 2008 16:22:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> But just allocating a big bucket of device numbers and throw it all into
> a pot semirandomly is likely to cause more damage, not less.

To use ext devt, the system has to use udev for device numbers.  As long
as udev is used, the major number doesn't matter.  In addition, breaking
drastically (e.g. can't find the device) seems better than subtle
failure (e.g. weird partition number calculation based on the
traditional minor number scheme) and CONFIG_DEBUG_BLOCK_EXT_DEVT is
exactly aimed at making breakages obvious.

I don't really see there's much to gain by sharing the original major
numbers.

Thanks.

-- 
tejun

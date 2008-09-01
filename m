Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYIAJnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYIAJnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYIAJnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:43:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:40248 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYIAJnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:43:11 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220194366-12731-13-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 10:43:07 +0100
Message-Id: <1220262187.2982.58.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-31 at 17:52 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> UBIFS stores 16-bit UUID in the superblock, and it is a good
> idea to return part of it in 'f_fsid' filed of kstatfs structure.

I think you mean a 16-byte UUID, not 16-bit?

> +	memcpy(&buf->f_fsid, c->uuid, sizeof(__kernel_fsid_t));

For btrfs I xor the first 64 bits with the second 64 bits, and put
_that_ into f_fsid. You're just putting the first 64 bits in and
ignoring the second 64 bits. Neither is really _better_ than the other;
you just alter the circumstances in which you get collisions. But I
suppose we might as well be consistent about how we do it?

(Actually I XOR in the root object ID for the subvol too, but you don't
need to worry about that).

Alternatively, there's space in the struct statfs to export a couple
more uint32_ts, and thus the _whole_ of the uuid. Perhaps we should do
that?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




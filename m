Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYBTSI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYBTSI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYBTSIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:08:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYBTSIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:08:18 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] fix invalidate_inode_pages2_range not to clear ret
References: <6.0.0.20.2.20080215132604.06091618@172.19.0.2>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 20 Feb 2008 13:08:10 -0500
In-Reply-To: <6.0.0.20.2.20080215132604.06091618@172.19.0.2> (Hisashi Hifumi's
	message of "Fri, 15 Feb 2008 13:36:32 +0900")
Message-ID: <x49mypv4i2d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> writes:

> Hi Andrew.
>
> DIO invalidates page cache through invalidate_inode_pages2_range().
> invalidate_inode_pages2_range() sets ret=-EIO when invalidate_complete_page2()
> fails, but this ret is cleared if do_launder_page() succeed on a page of next index. 
> In this case, dio is carried out even if invalidate_complete_page2() fails on some pages.
> This can cause inconsistency between memory and blocks on HDD because the page
> cache still exists.
>
> Following patch fixes this issue.

I agree with the patch (and I see Andrew already accepted it).  Do you
have a reproducer for this problem?

Cheers,

Jeff

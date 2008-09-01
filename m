Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYIARZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYIARZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYIARZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:25:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:51677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYIARZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:25:08 -0400
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in
	MEMGETREGIONINFO	ioctl()
From: David Woodhouse <dwmw2@infradead.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <48BBDDC9.9020003@gmail.com>
References: <48ABCC0B.40607@gmail.com>
	 <20080822153451.bb79bd1f.akpm@linux-foundation.org>
	 <48AFC5ED.50005@gmail.com>
	 <20080823222707.2fb972b5.akpm@linux-foundation.org>
	 <48B13F88.3080306@gmail.com>  <48B4D884.5040204@gmail.com>
	 <1220266884.2982.62.camel@pmac.infradead.org>  <48BBDDC9.9020003@gmail.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 18:25:03 +0100
Message-Id: <1220289903.2982.92.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 05:19 -0700, Zev Weiss wrote:
> From: Zev Weiss <zevweiss@gmail.com>
> Date: Mon, 1 Sep 2008 05:02:12 -0700
> Subject: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()
> 
> The MEMGETREGIONINFO ioctl() in mtdchar.c was clobbering user memory by
> overwriting more than intended, due the size of struct mtd_erase_region_info
> changing in commit 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8.
> 
> Fix avoids this by copying struct members one by one with put_user(), as there
> is no longer a convenient struct to use the size of as the length argument to
> copy_to_user().
> 
> Signed-off-by: Zev Weiss <zevweiss@gmail.com>

Thanks. Your patch was whitespace-damaged, but I managed to apply it
anyway. Please check for future patches though -- try sending patches to
yourself and then see if they get mangled. I believe gmail is known to
be broken unless you submit mail with SMTP.

I also try to avoid the pointless types like 'u32' in MTD code -- the C
language has perfectly good explicitly sized types; let's use them.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




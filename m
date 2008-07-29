Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYG2WBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYG2WBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYG2WBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:01:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886AbYG2WBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:01:38 -0400
Date: Tue, 29 Jul 2008 15:00:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: cooloney@kernel.org, michael.hennerich@analog.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 2.6.26-git 1/2] MTD DataFlash: bugfix, binary
 page sizes now handled (v3)
Message-Id: <20080729150052.80e558db.akpm@linux-foundation.org>
In-Reply-To: <200807251549.12565.david-b@pacbell.net>
References: <1212467165-26379-1-git-send-email-cooloney@kernel.org>
	<200806282321.34275.david-b@pacbell.net>
	<200807251549.12565.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 15:49:12 -0700
David Brownell <david-b@pacbell.net> wrote:

> This fixes a bug in handling certain newer DataFlash chips (at45db321d
> and at45db642d have current Linux users) when they were configured to
> use binary page sizes (possibly at the factory).
> 
>  - Use JEDEC probing (borrowed from m25p80 driver) to tell if the chip
>    supports binary page sizes ... if so, then query the chip to tell
>    whether it's currently using them.
> 
>  - Print that pagesize during probe; erasesize is still listed in 
>    the /proc/mtd file, useful for making filesystems.
> 
> Also fix a pre-existing bug with 2 MBit parts using the wrong pagesize;
> these are a bit smaller than Linux would normally use (even shared with
> a small FPGA's configuration bitstream).

I'm not sure what kernel this is against, but it gets a reject storm
against 2.6.27-rc1.  As does [2/2].

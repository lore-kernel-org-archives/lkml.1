Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0BBLXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:23:48 -0500
Received: from sh.osrg.net ([192.16.179.4]:33300 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0BBLXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:23:47 -0500
Date: Tue, 2 Feb 2010 20:23:38 +0900
To: JBottomley@Novell.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1264614691.3075.19.camel@mulgrave.site>
References: <1264614691.3075.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100202181736G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Feb 2010 20:23:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 11:51:30 -0600
James Bottomley <JBottomley@Novell.com> wrote:

> This is just a few minor fixes ... the biggest are that the BSG device
> will actually now work in compat (32 on 64 bit mode).

No, it will not work since there were two bugs...


> Harish Zunjarrao (1):
>       fc-transport: Use packed modifier for fc_bsg_request structure.

This fixes the alignment issue in struct fc_bsg_request but we still
have another bug in bsg's ioctl (SG_IO) with 32-bit userspace and
64-bit kernelspace.

http://marc.info/?l=linux-scsi&m=126268812704405&w=2

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142Ab0ARQ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0ARQ76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606Ab0ARQ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:59:57 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48379 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0ARQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:59:56 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Mon, 18 Jan 2010 18:00:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001170138.37283.rjw@sisk.pl> <201001171455.55909.rjw@sisk.pl>
In-Reply-To: <201001171455.55909.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001181800.38574.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Januar 2010 14:55:55 schrieb Rafael J. Wysocki:
> +void mm_force_noio_allocations(void)
> +{
> +       /* Wait for all slowpath allocations using the old mask to complete */
> +       down_write(&gfp_allowed_mask_sem);
> +       saved_gfp_allowed_mask = gfp_allowed_mask;
> +       gfp_allowed_mask &= ~(__GFP_IO | __GFP_FS);
> +       up_write(&gfp_allowed_mask_sem);
> +}

In addition to this you probably want to exhaust all memory reserves
before you fail a memory allocation and forbid the OOM killer to run.

	Regards
		Oliver

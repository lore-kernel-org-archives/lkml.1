Return-Path: <linux-kernel-owner+w=401wt.eu-S965975AbXDIV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965975AbXDIV3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXDIV3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:29:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:32957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250AbXDIV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:28:58 -0400
Date: Mon, 9 Apr 2007 14:28:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 3/4] Quicklist support for x86_64
Message-Id: <20070409142852.40da5add.akpm@linux-foundation.org>
In-Reply-To: <20070409182520.8559.33529.sendpatchset@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
	<20070409182520.8559.33529.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Apr 2007 11:25:20 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> -static inline pgd_t *pgd_alloc(struct mm_struct *mm)
> +static inline void pgd_ctor(void *x)
> +static inline void pgd_dtor(void *x)

Seems dumb to inline these - they're only ever called indirectly, aren't
they?

This means (I think) that the compiler will need to generate an out-of-line
copy of these within each compilation unit which passes the address of these
functions into some other function.

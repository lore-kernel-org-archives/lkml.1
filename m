Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZELWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZELWLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZELWLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:11:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbZELWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:11:03 -0400
Date: Tue, 12 May 2009 15:05:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Yang <leoli@freescale.com>
Cc: galak@kernel.crashing.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org, leoli@freescale.com,
       zw@zh-kernel.org
Subject: Re: [PATCH 3/6] powerpc: add memory map support to Freescale
 RapidIO block
Message-Id: <20090512150552.a98dca64.akpm@linux-foundation.org>
In-Reply-To: <1242117363-14949-3-git-send-email-leoli@freescale.com>
References: <1242117363-14949-1-git-send-email-leoli@freescale.com>
	<1242117363-14949-2-git-send-email-leoli@freescale.com>
	<1242117363-14949-3-git-send-email-leoli@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 16:36:00 +0800
Li Yang <leoli@freescale.com> wrote:

> +	align = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
> +
> +	/* Align the size */
> +	if ((lstart + size) > (_ALIGN_DOWN(lstart, align) + align)) {

__ilog2() and _ALIGN_DOWN() are powerpc-specific functions.  It would
be preferable to use more general helpers if possible.  ALIGN() and ilog2()
might suit here.



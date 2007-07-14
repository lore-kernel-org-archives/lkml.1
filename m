Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXGNQSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXGNQSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXGNQSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:18:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44942 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbXGNQSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:18:35 -0400
Date: Sat, 14 Jul 2007 17:18:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] Text Edit Lock - i386
Message-ID: <20070714161831.GA13831@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070714012133.612727310@polymtl.ca> <20070714012412.380213021@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012412.380213021@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:21:36PM -0400, Mathieu Desnoyers wrote:
> +#ifdef CONFIG_DEBUG_RODATA
> +static int rodata_marked;
> +#endif

Maybe I'm missing something, but the rodata section should always stay
r/o, only text needs locking/unlocking, no?

Given that all code in this patch only operates on .text this seems fine,
but the variables/config options are grossly misnamed then.  And actually
making rodata r/o doesn't seem like a pure debugging thing to me either.

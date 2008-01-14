Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYANHmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYANHmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 02:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYANHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 02:41:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYANHl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 02:41:56 -0500
Date: Mon, 14 Jan 2008 07:41:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Fix kprobes on ia64
Message-ID: <20080114074151.GA15431@infradead.org>
References: <20080114022423.GH18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114022423.GH18741@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 07:24:24PM -0700, Matthew Wilcox wrote:
> If CONFIG_KPROBES is set, we get the error during build:
> 
> kernel/kprobes.c:1057: error: __ksymtab_jprobe_return causes a section
> type conflict
> 
> This is because ia64 defines a static inline jprobe_return which kprobes
> attempts to EXPORT_SYMBOL.

Given that jprobe_return is defined in the arch-specific kprobes.c file
it would be better to export it there instead of in kernel/kprobe.c, or
in case of ia64 not export it at all.


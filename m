Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYANGDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYANGDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYANGC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:02:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36532 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYANGCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:02:55 -0500
Date: Mon, 14 Jan 2008 07:02:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Fix kprobes on ia64
Message-ID: <20080114060256.GB5187@uranus.ravnborg.org>
References: <20080114022423.GH18741@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114022423.GH18741@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 07:24:24PM -0700, Matthew Wilcox wrote:
> 
> If CONFIG_KPROBES is set, we get the error during build:
> 
> kernel/kprobes.c:1057: error: __ksymtab_jprobe_return causes a section
> type conflict
> 
> This is because ia64 defines a static inline jprobe_return which kprobes
> attempts to EXPORT_SYMBOL.

The better fix is to let jprobe_return be a normal function that can be exported.
Then we avoid this arch specific ifdef for the cost of nothing.

	Sam

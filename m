Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYFOVcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYFOVcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYFOVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 17:32:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYFOVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 17:32:39 -0400
Subject: Re: [PATCH] export linux/a.out.h
From: David Woodhouse <dwmw2@infradead.org>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <1213564021-5195-1-git-send-email-jacmet@sunsite.dk>
References: <1213564021-5195-1-git-send-email-jacmet@sunsite.dk>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 22:32:35 +0100
Message-Id: <1213565555.26255.522.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 23:07 +0200, Peter Korsgaard wrote:
> Export linux/a.out.h like we do for asm/a.out.h as some applications needs
> it (E.G. valgrind). One minor complication is that the interesting stuff is
> protected by an CONFIG_ARCH_SUPPORTS_AOUT ifdef, so make sure that gets
> defined for unifdef.

No, let's fix the file instead. We should never have wrapped its
contents in CONFIG_ARCH_SUPPORTS_AOUT in the first place.

And we don't want to export it unconditionally. We want something like
we already have in include/asm-generic/Kbuild.asm:

ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
unifdef-y += a.out.h
endif

-- 
dwmw2


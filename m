Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYFHKtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYFHKtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYFHKtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:49:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbYFHKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:49:06 -0400
Subject: Re: [PATCH] Speed up "make headers_*"
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
In-Reply-To: <20080608104122.GA10545@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
	 <20080608104122.GA10545@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 11:49:01 +0100
Message-Id: <1212922141.32207.495.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 12:41 +0200, Sam Ravnborg wrote:
> headers_install.pl looks like this now.
> I am not happy about the way I call unifdef - can it be
> done better?

Possibly. unifdef only actually handles "#ifdef __KERNEL__" and
"#ifndef __KERNEL__", doesn't it? It shouldn't be too hard to recreate
at least that much functionality in perl, surely?

Bonus points for making it handle more interesting constructs like
"#if defined (KERNEL) || defined (FOO)", and for warning/erroring
whenever any ifdefs on CONFIG_xxx would be visible in userspace.
But those can come later; we don't have those yet anyway.

-- 
dwmw2


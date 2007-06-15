Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXFOMir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXFOMir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbXFOMik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:38:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41634 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbXFOMii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:38:38 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070615121133.GF8154@parisc-linux.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
	 <1181897905.26853.66.camel@localhost.localdomain>
	 <200706151128.39566.arnd@arndb.de> <200706151131.38429.arnd@arndb.de>
	 <20070615121133.GF8154@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 13:38:32 +0100
Message-Id: <1181911112.25228.472.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 06:11 -0600, Matthew Wilcox wrote:
> You're relying on compat_[us]64 being only used in structures which are
> already packed. 

In which case the whole exercise is pointless, on account of the
structure being already packed. It was _already_ laid out the same on
32-bit and 64-bit builds.

>  If someone uses them in a non-packed struct, they won't
> decrease the alignment.  I think it would be more effective to specify
> it as:
> __attribute__((aligned(4), packed))

Good point. Yes, it looks like we need the additional 'packed' in order
for the aligned(4) to be anything other than a no-op.

-- 
dwmw2


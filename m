Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbXFOMrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbXFOMrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbXFOMrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:47:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41683 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXFOMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:47:15 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200706151440.10273.ak@suse.de>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
	 <200706151355.57464.ak@suse.de> <200706151403.53855.arnd@arndb.de>
	 <200706151440.10273.ak@suse.de>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 13:47:08 +0100
Message-Id: <1181911628.25228.483.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 14:40 +0200, Andi Kleen wrote:
> > That is broken on all non-x86 architectures, 

> It cannot be broken, it just might be somewhat slower 

No, Andi. It's broken.

We're speaking of a 32-bit ioctl compat routine. I would say it's more
than 'convention' that the structure used by the compat_ioctl routine
actually matches the 'real' structure as it gets laid out on the 32-bit
architecture.

The 'real' structure as used by the 32-bit userspace does not have the
'packed' attribute. Thus the u64 member of the structure is aligned to 8
bytes on _all_ relevant 32-bit architectures except for i386.

By adding 'packed' in the compat_ioctl routine, you cause it to expect a
structure which does not match what userspace is using, for all non-x86
architectures. That's kind of not very compatible. I call that 'broken'.

-- 
dwmw2


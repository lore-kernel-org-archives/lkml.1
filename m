Return-Path: <linux-kernel-owner+w=401wt.eu-S934683AbYDQKIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbYDQKIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934326AbYDQJ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:59:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48620 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935628AbYDQJ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:59:41 -0400
Date: Thu, 17 Apr 2008 10:59:16 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] ARM: always select HAVE_IDE
Message-ID: <20080417095916.GD1449@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080415221002.GL1677@cs181133002.pp.htv.fi> <20080415223928.GH5676@flint.arm.linux.org.uk> <200804160126.11116.bzolnier@gmail.com> <20080417093753.GF1677@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417093753.GF1677@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 12:37:53PM +0300, Adrian Bunk wrote:
> Any objections against the patch below?

Let's look at the rest of the situation surrounding HAVE_IDE first.
It's something of a mess:

avr32, m68knommu, ppc, s390 and v850 do not have asm/ide.h

avr32, m68knommu, ppc, v850 all set HAVE_IDE, arch/s390/Kconfig contains
no reference.

avr32 supports PATA (which is IDE).

Everything else provides an asm/ide.h and sets HAVE_IDE.

So:

Q1. Do avr32, m68knommu, ppc, v850 have IDE support or do they not?
Q2. Should avr32, m68knommu, ppc, v850 supply an asm/ide.h header?
Q3. Is it worth supporting HAVE_IDE for all kernel architectures when
    its just one (s390) which supports neither IDE nor ATA - or would
    something more generic covering both be appropriate.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

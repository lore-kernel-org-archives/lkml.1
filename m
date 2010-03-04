Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0CDVob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:44:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52162 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0CDVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:44:29 -0500
Date: Thu, 4 Mar 2010 21:40:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>, mdharm-kernel@one-eyed-alien.net,
       oliver@neukum.org, tom.leiming@gmail.com, greg@kroah.com,
       x0082077@ti.com, sshtylyov@ru.mvista.com,
       Catalin Marinas <catalin.marinas@arm.com>, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       santosh.shilimkar@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100304214030.GI13417@n2100.arm.linux.org.uk>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk> <1267316072.23523.1842.camel@pasglop> <1267333263.2762.11.camel@mulgrave.site> <20100302211049V.fujita.tomonori@lab.ntt.co.jp> <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com> <20100303215437.GF2579@ucw.cz> <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com> <20100304135128.GA12191@atrey.karlin.mff.cuni.cz> <1267712512.31654.176.camel@mulgrave.site> <1267738114.22204.70.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267738114.22204.70.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 08:28:34AM +1100, Benjamin Herrenschmidt wrote:
> I don't think there's a core or driver problem in this specific case. As
> we discussed earlier, I believe the problem is that ARM considers a
> fresh page out of the page cache as "clean" instead of "dirty", and
> inverting that like we do on powerpc will fix their problem too.

The only concern is that it means we treat anonymous pages as dirty
by default.

That's quite sub-optimal since we take care (eg) on write faults to
copy the page and take care of the cache issues while we do that -
whether that be remapping the page to be coherent with the user
address, or cleaning each cache line as we copy the data.

Of course, the simple solution is to also arrange for PG_arch_1 to be
set in this case.

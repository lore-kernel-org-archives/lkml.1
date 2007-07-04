Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbXGDKXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbXGDKXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbXGDKXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:23:23 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:40991 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXGDKXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:23:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent;
	b=r4BdjLFgtIEEbR43B2yiCAKKH0qJU21MPbA+Rt+u52EVeB7Mbr60RyNBsBZGl
	2n7ILej3VJGaWhwkcRKb9U+rA==
Date: Wed, 4 Jul 2007 12:23:18 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: tglx@linutronix.de, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: handle_futex_death() infinite loop on ARM (fwd)
Message-ID: <20070704102318.GA18634@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Forwarded message from Lennert Buytenhek <buytenh@wantstofly.org> -----

Date: Wed, 13 Jun 2007 20:40:40 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: handle_futex_death() infinite loop
User-Agent: Mutt/1.4.1i

Hi,

If you're also running into glibc's tst-robust1 test suite test
locking up your ARM machine, you're probably running into the fact
that asm-arm/futex.h includes asm-generic/futex.h, and
asm-generic/futex.h defines futex_atomic_cmpxchg_inatomic() to
return -ENOSYS.  This causes handle_futex_death() to loop forever.


cheers,
Lennert

----- End forwarded message -----

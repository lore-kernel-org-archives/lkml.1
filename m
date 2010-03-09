Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0CIKT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:19:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37822
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190Ab0CIKT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:19:56 -0500
Date: Tue, 09 Mar 2010 02:20:15 -0800 (PST)
Message-Id: <20100309.022015.162981335.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: mkl0301@gmail.com, thomas@koeller.dyndns.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: DMA using data buffer vmapped in kernel space
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100309101611.GC5691@n2100.arm.linux.org.uk>
References: <20100309091403.GB5691@n2100.arm.linux.org.uk>
	<20100309.012935.98310472.davem@davemloft.net>
	<20100309101611.GC5691@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Tue, 9 Mar 2010 10:16:11 +0000

> It looks like the firmware interface may return a pointer to either the
> kernel binary itself for built-in firmware, or to a set of pages which
> have been vmap'd.  In the former case, vmalloc_to_page() will fail.

Indeed, then you're right, the firmware layer would need to provide
the interface since only it knows where the memory is.

However, there's also no real portable way to compute physical
addresses from kernel image virtual addresses.

BTW, it's been my experience that drivers copy the firmware into a
locally allocated buffer exactly to avoid this problem.

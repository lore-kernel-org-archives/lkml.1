Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbXEQJBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbXEQJBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXEQJBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:01:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41118 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655AbXEQJBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:01:34 -0400
Date: Thu, 17 May 2007 10:04:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@osdl.org, akpm@osdl.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NS16550A: Restore HS settings in EXCR2 on resume
Message-ID: <20070517100439.3fb749cb@the-village.bc.nu>
In-Reply-To: <1179383259.2859.420.camel@shinybook.infradead.org>
References: <1179383259.2859.420.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 14:27:39 +0800
David Woodhouse <dwmw2@infradead.org> wrote:

> After a suspend/resume cycle, the UART may have been reset into
> low-speed mode -- either because it's actually been reset, or because
> the firmware pokes at the old-style divisor registers. If we detected it
> as a NS16550A SuperIO chip in the first place and set baud_base to
> 921600, then we should do so again in the resume path.
> 
> This patch adds that code to serial8250_resume_port(), and also makes
> serial8250_resume() actually call serial8250_resume_port() for each port
> instead of just calling uart_resume_port() directly. And thus fixes
> serial port operation after suspend/resume.
> 
> It also fixes a bogus comment where we write the EXCR2 register with a
> comment saying /* EXCR1 */
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Alan Cox <alan@redhat.com>


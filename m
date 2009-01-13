Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbZAMVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbZAMVzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZAMVzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:55:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZAMVzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:55:38 -0500
Date: Tue, 13 Jan 2009 16:55:26 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Helge Deller <deller@gmx.de>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, "Rafael J. Wysocky" <rjw@sisk.pl>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix early_serial_setup() regression
Message-ID: <20090113215526.GG25103@bombadil.infradead.org>
References: <496D0CCB.1020706@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D0CCB.1020706@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 10:51:07PM +0100, Helge Deller wrote:
> commit b430428a188e8a434325e251d0704af4b88b4711,
> 	"8250: Don't clobber spinlocks."
> introduced a regression on the parisc architecture, which
> broke the handover to the serial port at boottime.
> 
> early_serial_setup() was changed to only copy a subset of the
> uart_port fields, and sadly the "type" and "line" fields
> were forgotten and thus the serial port was not initialized
> and could not be used for a handover.
> This patch fixes this by copying the missing fields.
> 
> As this change to early_serial_setup() doesn't need an 
> initialized spinlock in the uart_port struct any longer, we
> can drop the spinlock initialization in the superio driver.
> 
> CC: David Daney <ddaney@caviumnetworks.com>
> CC: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Kyle McMartin <kyle@mcmartin.ca>
> CC: linux-parisc@vger.kernel.org
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 

Acked-by: Kyle McMartin <kyle@mcmartin.ca>

Linus, please apply.

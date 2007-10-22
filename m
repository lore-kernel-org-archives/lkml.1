Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXJVTrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXJVTrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXJVTrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:47:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58494 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXJVTrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:47:15 -0400
Date: Mon, 22 Oct 2007 13:47:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-ID: <20071022194714.GI27248@parisc-linux.org>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <20071022152912.GA841@linux-mips.org> <20071022112110.105b8e11.akpm@linux-foundation.org> <200710222110.34768.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710222110.34768.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:10:34PM +0200, Arnd Bergmann wrote:
> On a related note, should we encourage the use of spin_lock() and
> spin_lock_irq() instead of spin_lock_irqsave() where possible?

spin_lock(), certainly.  On PowerPC, I'm reliably informed it's fewer
instructions to save/restore than it is to disable/enable.  So no clear
advantage there.

> On some architectures, accessing the interrupt flag is a heavyweight
> operation, especially when running under a hypervisor, so a number
> of drivers could benefit from being converted to not save the flags
> at all instead of just changing the type of the flags variable.

We certainly don't want to encourage people to blindly make those
conversions ... and I've seen the results of encouraging kernel janitors
to do things a certain way.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

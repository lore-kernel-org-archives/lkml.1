Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXLZQrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXLZQrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 11:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXLZQrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 11:47:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXLZQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 11:47:39 -0500
Date: Wed, 26 Dec 2007 02:17:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Bloch <matthew@bytemark.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071226021756.7ae9db08@laptopd505.fenrus.org>
In-Reply-To: <20071225230957.GB29030@elf.ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org>
	<20071222120959.475ebced@laptopd505.fenrus.org>
	<20071225230957.GB29030@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007 00:09:57 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Sat 2007-12-22 12:09:59, Arjan van de Ven wrote:
> > On Tue, 18 Dec 2007 17:06:24 +0000

> > memtest86+ does various magic to basically bypass the caches (by
> > disabling them ;-)... Doing that in a live kernel situation, and
> > from userspace to boot...... that's... and issue.
> 
> Are you sure? I always assumed that memtest just used patterns bigger
> than L1/L2 caches...

that's... not nearly usable or enough. Caches are relatively smart
about things like use-once.... and they're huge. 12Mb today. You'd need
patterns bigger than 100Mb to get even close to being reasonably
confident that there's nothing left.

> ... and IIRC my celeron testing confirmed it, if
> I disabled L2 cache in BIOS, memtest behave differently.
> 
> Anyway, if you can do iopl(), we may as well let you disable caches,
> but you are right, that will need a kernel patch.

and a new syscall of some sorts I suspect; "flush all caches" is a ring
0 operation (and you probably need to do it in an ipi anyway on all
cpus)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

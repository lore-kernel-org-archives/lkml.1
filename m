Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbYBULBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbYBULBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbYBULBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:01:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39910 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758636AbYBULBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:01:10 -0500
Date: Thu, 21 Feb 2008 10:50:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] viocons: BKL locking
Message-ID: <20080221105056.69e6678c@core>
In-Reply-To: <18364.63205.933131.746580@cargo.ozlabs.ibm.com>
References: <20080220203258.4b33f890@core>
	<18364.63205.933131.746580@cargo.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 14:58:29 +1100
Paul Mackerras <paulus@samba.org> wrote:

> Alan Cox writes:
> 
> > For some weird reason I can't ascertain (translation "I think its
> > broken") the viocons driver calls directly into the n_tty ldisc code even
> > if another ldisc is in use. It'll probably break if you do that but I'm
> > just fixing the locking and adding a comment that its horked.
> 
> Looks to me like it (viotty_ioctl) should return -ENOIOCTLCMD instead
> of calling n_tty_ioctl -- do you agree?

I think that is probably what is intended. That would then bounce back
throuh the tty layer to the right places.

Alan

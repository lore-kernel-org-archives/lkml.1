Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYJFK5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYJFK5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYJFK5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:57:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYJFK5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:57:01 -0400
Date: Mon, 6 Oct 2008 06:56:59 -0400
From: Alan Cox <alan@redhat.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/76] tty: Make get_current_tty use a kref
Message-ID: <20081006105659.GB9606@shell.devel.redhat.com>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005161021.1997.38953.stgit@localhost.localdomain> <20081006103540.GC29198@hawkmoon.kerlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006103540.GC29198@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.4.2.2i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 12:35:40PM +0200, Louis Rilling wrote:
> >  		tty = get_current_tty();
> >  		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
> > -			mutex_unlock(&tty_mutex);
> > +			tty_kref_put(tty);
> 
> Should'nt mutex_unlock() be kept?

Yes.. although it gets fixed later but I will fix that as it will keep the
code bisectable.

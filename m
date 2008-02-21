Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbYBUD6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbYBUD6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYBUD6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:58:38 -0500
Received: from ozlabs.org ([203.10.76.45]:54727 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYBUD6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:58:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.63205.933131.746580@cargo.ozlabs.ibm.com>
Date: Thu, 21 Feb 2008 14:58:29 +1100
From: Paul Mackerras <paulus@samba.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] viocons: BKL locking
In-Reply-To: <20080220203258.4b33f890@core>
References: <20080220203258.4b33f890@core>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:

> For some weird reason I can't ascertain (translation "I think its
> broken") the viocons driver calls directly into the n_tty ldisc code even
> if another ldisc is in use. It'll probably break if you do that but I'm
> just fixing the locking and adding a comment that its horked.

Looks to me like it (viotty_ioctl) should return -ENOIOCTLCMD instead
of calling n_tty_ioctl -- do you agree?

Paul.

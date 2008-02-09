Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYBIX51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYBIX51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 18:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbYBIX5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 18:57:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34115 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbYBIX5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 18:57:19 -0500
Date: Sat, 9 Feb 2008 15:57:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Query about set_pages_* API
Message-ID: <20080209155707.787ddc47@laptopd505.fenrus.org>
In-Reply-To: <47AE2BCC.3040605@lwfinger.net>
References: <47AE2BCC.3040605@lwfinger.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Feb 2008 15:40:12 -0700
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I'm trying to modify the VirtualBox kernel module to work with
> 2.6.24-git (and 2.6.25) on x86_64 architecture. The current code has
> a value of the third argument of the call (prot) with 3 variants. All
> variations have the following bits set: _PAGE_PRESENT, _PAGE_RW,
> _PAGE_DIRTY, and _PAGE_ACCESSED. Number 2 adds _PAGE_NX to the above,
> and number 3 adds _PAGE_GLOBAL to the bits in variation 1.
> 
>  From the code in arch/x86/mm/pageattr.c, I figured I need to call
> set_pages_wb() unconditionally, and set_pages_nx() if _PAGE_NX is
> set. Will these calls be sufficient? I thought about calling
> set_pages_rw(), but that entry is not exported.

it depends on what the code is trying to achieve.
(this makes it not a trivial 1:1 scripted replacement ;-)

Which attribute is the code trying to change? Is it trying to make
a piece of code (non) cachable? or executable? You need to figure out what
the intent is..


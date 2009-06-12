Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbZFLKhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbZFLKhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764020AbZFLKhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:37:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57522 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757740AbZFLKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:37:10 -0400
Date: Fri, 12 Jun 2009 11:38:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix unused warning when TCGETX is not defined
Message-ID: <20090612113830.6c21dfc9@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com>
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org>
	<20090612113320.73e6f7f1@lxorguk.ukuu.org.uk>
	<8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If I wasn't so nice I'd just make it and the lack of BOTHER definitions
> > on platforms error. Really there shouldn't be anyone without the features
> > defined ;)
> 
> if i knew a lick about these extended tty pieces, i'd look at hooking them up
> 
> are these really arch specific ?

The ioctl numbers have to be (although most platforms use the same
values), and the "BOTHER" definition for arbitary baud rates depends on
the format of struct termios - which again varies by architecture. Its
usually the case that CBAUDEX|0 isn't used for anything so we use that
for BOTHER.

Other than the numbering they are not arch specific, so just pick the
constants for the platform.

Alan

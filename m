Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZKESbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZKESbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbZKESbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:31:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38063 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753638AbZKESbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:31:02 -0500
Date: Thu, 5 Nov 2009 18:32:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zan Lynx <zlynx@acm.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       mk@cm4all.com
Subject: Re: [PATCH] pipe: don't block after data has been written
Message-ID: <20091105183240.4f67aadc@lxorguk.ukuu.org.uk>
In-Reply-To: <4AF307A6.2010101@acm.org>
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net>
	<4AF2FD04.4030306@gmail.com>
	<20091105163603.GA4089@squirrel.roonstrasse.net>
	<4AF2FF5A.6050205@gmail.com>
	<4AF307A6.2010101@acm.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Welcome to real world.
> 
> Yes in the real world there are bugs. The decision is to choose which 
> bug you are going to expose. If it was my decision I would make the code 
> work as documented, as Max wants to do.

Outside of academia the reality is fairly simple. A system needs to
behave according to the expected behaviour. That is a mix of things
- Standards
- Extrapolation (applying the logic of the standard to cases beyond it)
- Tradition (things that used to work still work)

If you like: How it is defined to work, how it is expected to work and how
it worked last year.

Tradition is a suprisingly large part of it. In the unix world that
tradition includes things like "signals do not interrupt disk I/O writes
causing short writes".

Pipes however is pretty much pure standards behaviour

In blocking mode they block
In non-blocking mode they don't block

Furthermore there are specific rules about writes under a certain size
always occurring in an atomic manner.

> In fact I think that Linux will already do short writes if a signal is 
> received without restart set for the handler. I found several bugs last 
> year in glibc and libstdc++ fwrite and iostreams regarding that.

The kernel takes great pains not to do this in the cases where tradition
dictates otherwise (notably in disk I/O)

Alan

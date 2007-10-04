Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXJDXjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXJDXjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbXJDXjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:39:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47702 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757579AbXJDXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:39:00 -0400
Date: Fri, 5 Oct 2007 00:41:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] getattr - fill the size of pipes
Message-ID: <20071005004149.0c9746dc@the-village.bc.nu>
In-Reply-To: <20071004162252.f0785c9f.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0710021952450.7130@fbirervta.pbzchgretzou.qr>
	<20071004162252.f0785c9f.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Cute feature, but it is (I assume) a Linux-specific extension and is
> something which we'll need to maintain for ever and it invites

Actually it used to work on the old old Linux pipe code.

> unportability to older Linuxes and other OSes and it introduces some risk
> of breakage of existing applications.  And it slows down fstat on a pipe.

Most Sys5 based boxes happen to put the right value there but not
everyone and its not guaranteed in the slightest
> 
> Given that the info can already be obtained via ioctl(FIONREAD) anyway, I
> don't think that (gain > pain)?

Nor me - any application trying to reduce the syscall count would just do
a very large read and get the data and size in one go.

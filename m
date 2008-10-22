Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYJVK1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYJVK1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYJVK07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:26:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55103 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbYJVK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:26:58 -0400
Date: Wed, 22 Oct 2008 11:27:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wolfgang Kroworsch <wolfgang@kroworsch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: incomplete initialization of vc_tab_stop
Message-ID: <20081022112705.10f9aa4a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081018114929.GA25554@kroworsch.de>
References: <20081018114929.GA25554@kroworsch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 13:49:31 +0200
Wolfgang Kroworsch <wolfgang@kroworsch.de> wrote:

> Problem 1 (see patch below):
>   vc_tab_stop is declared as an array of 8 unsigned ints in struct
>   vc_data in include/linux/console_struct.h .
>   In drivers/char/vt.c only 5 of these 8 unsigned ints get initialized
>   leading to unintended tabulator placement on displays with more than
>   160 columns text.

Seems sensible enough - but need a Signed-off-by line to apply.

> 
> Problem 2 (open):
>   Upcoming displays will have more than 256 columns of text leading to
>   invalid memory access in drivers/char/vt.c during tabulator
>   calculations:
>     if (vc->vc_tab_stop[vc->vc_x >> 5] & (1 << (vc->vc_x & 31)))
> 	break;

Yes. We should either limit the vt size or grow the tables.

Alan

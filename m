Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXJZATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXJZATs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXJZATj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:19:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60490 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237AbXJZATi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:19:38 -0400
Date: Fri, 26 Oct 2007 01:22:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
Message-ID: <20071026012217.4cc30390@the-village.bc.nu>
In-Reply-To: <20071025230758.945535769@crlf.corp.google.com>
References: <20071025230758.945535769@crlf.corp.google.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 16:06:40 -0700
Mike Waychison <mikew@google.com> wrote:

> Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.
> 
> It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.

Historically this was done because people felt it was more secure. It
also allows you to make some deductions about other activities on the
disk but thats probably only a concern for very very security crazed
compartmentalised boxes

Also historically at least FIBMAP could be abused to crash the system.
Now if you can verify that has been fixed I have no problem, but given
that I can find no record of that being fixed it would be wise to audit
it first and review Chris Evans and other reports about what occurs when
FIBMAP is passed random block numbers.

FIBMAP has another problem for this general use as well - it takes an int
but the block number can now be bigger for very large files on 32bit.

Alan

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXGWGNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXGWGNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXGWGN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:13:28 -0400
Received: from ozlabs.org ([203.10.76.45]:59500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbXGWGN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:13:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18084.18177.369567.679866@cargo.ozlabs.ibm.com>
Date: Mon, 23 Jul 2007 16:13:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland McGrath <roland@redhat.com>
Cc: David Miller <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: <20070723060155.2B3824D0489@magilla.localdomain>
References: <20070722.012321.79430375.davem@davemloft.net>
	<20070723060155.2B3824D0489@magilla.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath writes:

> It turns out the problem here is that some .o files wind up with their own
> .note.gnu.build-id sections.  I got the makefile magic wrong, thinking that
> LDFLAGS_MODULE was a variable specifically for .ko links.  It's also used
> in cmd_link_multi-m.

Alan Modra (binutils hacker) has said to me in the past that using
ld -r to combine the objects in each directory is bad; he would much
rather that we gave all the individual objects to the final link,
since that enables ld to do better optimizations on some targets.  We
could actually do that quite easily by making the built-in.o files be
linker scripts listing the individual objects rather than creating
them with ld -r.

Paul.

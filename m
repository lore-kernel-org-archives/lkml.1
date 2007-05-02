Return-Path: <linux-kernel-owner+w=401wt.eu-S2993059AbXEBL7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993059AbXEBL7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993056AbXEBL7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:59:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50453 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993054AbXEBL7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:59:15 -0400
Date: Wed, 2 May 2007 13:02:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
Message-ID: <20070502130204.2cc2fd1a@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0705011719520.3808@woody.linux-foundation.org>
References: <4637AC3D.6000008@freedesktop.org>
	<alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
	<4637D47D.7040203@freedesktop.org>
	<alpine.LFD.0.98.0705011719520.3808@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 17:24:54 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 1 May 2007, Josh Triplett wrote:
> > 
> > Do you know whether the current version of GCC generates poor code for pointer
> > subtraction?
> 
> You _cannot_ generate good code.
> 
> When you subtract two pointers, the C definition means that you first 
> subtract the values (cheap), and then you *divide* the result by the size 
> of the object the pointer points to (expensive!).

Good compilers even in the 1990's would defer the divide and try and
propogate it out as a multiply the other side for constants, and they'll
also use shifts when possible.

Thus they'll turn

	(ptr.element - base.element) < NELEM

into
	(ptr.char - base.char) < (constant) [NELEM *sizeof(element) ]


at least for constant operations. Dunno if gcc is that clever

Alan

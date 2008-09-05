Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYIEUrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYIEUrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYIEUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:46:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43260 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYIEUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:46:58 -0400
Date: Fri, 5 Sep 2008 12:37:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: Re: [uml-devel] [PATCH 2/6] UML: Don't valgrind userspace
Message-ID: <20080905163718.GA11455@c2.user-mode-linux.org>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291614430.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0808291614430.15543@abydos.NerdBox.Net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 04:15:24PM -0700, Steve VanDeBogart wrote:
> Add a flag to tell Valgrind to run the forked child natively.  Necessary
> because Valgrind makes additional system calls to instrumented processes,
> which confuse UML.

> +#ifdef UML_CONFIG_VALGRIND_SUPPORT
> +		flags |= VALGRIND_CLONE_LETGO;
> +#endif
> +	}

I keep forgetting that I have a really bad feeling about this:

+#define VALGRIND_CLONE_LETGO   0x80000000      /* do not track fork like childr
en*/

This is effectively appropriating part of the kernel's ABI for
valgrind's use.  Not to mention that that bit is already taken:

#define CLONE_IO		0x80000000	/* Clone io context */

Could you do this with an annotation that says "let the next clone run
untraced"?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
